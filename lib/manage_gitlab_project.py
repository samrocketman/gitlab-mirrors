#!/usr/bin/env python3
# Created by Sam Gleske
# MIT License
# Created Tue Sep 10 23:01:08 EDT 2013

import logging
import sys
import argparse
import os
from typing import Optional, Union

try:
    import gitlab
    import gitlab.v4
    from gitlab.v4.objects import Group, Project
except ImportError as import_exc:
    raise ImportError(
        "python-gitlab module is not installed.  You probably didn't read the install instructions closely enough.  See docs/prerequisites.md."
    ) from import_exc

VERBOSE = "DEBUG" in os.environ

try:
    token_secret = os.environ["gitlab_user_token_secret"]
    gitlab_url = os.environ["gitlab_url"]
    gitlab_toplevel_group = os.environ["gitlab_namespace"]
    gitlab_user = os.environ["gitlab_user"]
    ssl_verify = os.environ["ssl_verify"]
    gitlab_api_version = os.environ["gitlab_api_version"]
except KeyError:
    print("Environment config missing.  Do not run this script standalone.", file=sys.stderr)
    sys.exit(1)


def str2bool(v):
    return v.lower() in ("yes", "true", "t", "1")


def create_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="A nontrivial modular command")
    p.add_argument("projectname", help="specific project name")
    p.add_argument("--issues", dest="issues", action="store_true", default=False)
    p.add_argument("--wall", dest="wall", action="store_true", default=False)
    p.add_argument("--merge", dest="merge", action="store_true", default=False)
    p.add_argument("--wiki", dest="wiki", action="store_true", default=False)
    p.add_argument("--snippets", dest="snippets", action="store_true", default=False)
    p.add_argument("--visibility", dest="visibility", choices=["public", "internal", "private"], default="private")
    p.add_argument("--create", dest="create", action="store_true", default=False)
    p.add_argument("--delete", dest="delete", action="store_true", default=False)
    p.add_argument("--desc", dest="desc", default="")
    p.add_argument("--http", dest="http", action="store_true", default=False)

    return p


def find_or_create_group(git, path: str, visibility: str):

    def find_group(git, path: str) -> Union[list[Group], Group]:
        logging.debug("Searching for group %s in %s", path, [g.full_path for g in git.groups.list(iterator=False, get_all=True)])
        groups = [g for g in git.groups.list(iterator=False, get_all=True) if g.full_path.lower() == path.lower()]
        return groups[0] if len(groups) == 1 else groups

    def creategroup(
        git: gitlab.Gitlab,
        group_path: str,
    ):
        group_name = group_path.split("/")[-1]
        parent_group_path = group_path.rstrip(group_name).strip("/")
        parent_group = find_group(git, parent_group_path)
        logging.info("Try creating group %s under parent %s", group_path, parent_group_path)
        if not parent_group:
            return False
        group_options = {
            "name": group_name,
            "path": group_name,
            "visibility": visibility,
            "parent_id": parent_group.id,
        }
        logging.debug("Creating group %s", group_options)
        git.groups.create(group_options)
        return True

    found_groups = find_group(git, path)
    if not found_groups:
        if not creategroup(git, path):
            first_group_segment = path.rsplit("/", 1)[0]
            find_or_create_group(git, first_group_segment, visibility)
        found_groups = find_or_create_group(git, path, visibility)
    return found_groups


def find_project(git, pn: str) -> Optional[Project]:
    logging.debug("Searching for project %s", pn)
    projects = [g for g in git.projects.list(iterator=False, get_all=True) if g.name.lower() == pn.lower()]
    return projects[0] if len(projects) == 1 else projects


# transfer the project from the source namespace to the specified group namespace
def transfer_project(git, src_project: Project, group: Group) -> Project:
    group.transfer_project(src_project.id)
    dest_project = find_project(git, src_project.name)
    return dest_project


def createproject(
    git: gitlab.Gitlab,
    pn: str,
    found_group: Group,
    visibility: str,
    desc: str,
    issues: bool,
    wall: bool,
    merge: bool,
    wiki: bool,
    snippets: bool,
):
    project_options = {
        "issues_enabled": issues,
        "jobs_enabled": "false",
        "wall_enabled": wall,
        "merge_requests_enabled": merge,
        "wiki_enabled": wiki,
        "snippets_enabled": snippets,
        "visibility": visibility,
        "namespace_id": found_group.id,
    }
    # make all project options lowercase boolean strings i.e. true instead of True
    for x in project_options.keys():
        project_options[x] = str(project_options[x]).lower()
    project_options["name"] = pn
    project_options["description"] = desc if desc else f"Public mirror of {pn}." if visibility == "public" else f"Git mirror of {pn}."
    logging.info("Creating new project %s with options %s", pn, project_options)
    git.projects.create(project_options)
    project_for_transfer = find_project(git, pn)
    if needs_transfer(gitlab_user, found_group, project_for_transfer):
        project_for_transfer = transfer_project(git, project_for_transfer, found_group)
    return project_for_transfer


# returns a Bool True if the transfer is required
def needs_transfer(user, groupname: Group, project: Project):
    namespace = groupname.full_path if groupname else user
    return project.namespace["full_path"] != namespace


if __name__ == "__main__":
    parser = create_parser()
    logging.getLogger().setLevel(logging.DEBUG if VERBOSE else logging.INFO)
    args = parser.parse_args()
    gitlab_connection = gitlab.Gitlab(
        gitlab_url,
        token_secret,
        ssl_verify=str2bool(ssl_verify),
        api_version=gitlab_api_version,
    )

    proj_name_args = args.projectname.strip("/")
    project_name = proj_name_args.split("/")[-1]

    full_project_path = gitlab_toplevel_group + "/" + proj_name_args
    full_project_path = full_project_path.strip("/")
    subgroup_path = full_project_path.rstrip(project_name).strip("/")

    found_projects = find_project(gitlab_connection, project_name)
    logging.debug("Found projects %s", found_projects)

    if args.create:
        group_in_namespace = find_or_create_group(gitlab_connection, subgroup_path, args.visibility)
        logging.debug("Found groups %s", group_in_namespace)
        assert group_in_namespace, f"Please create groups {subgroup_path} manually"

        if found_projects:
            if needs_transfer(gitlab_user, group_in_namespace, found_projects):
                found_projects = transfer_project(
                    gitlab_connection, found_projects, group_in_namespace
                )
                if not found_projects:
                    logging.error(
                        "There was a problem transferring %s/%s.  Did you give %s user Admin rights in gitlab?",
                        group=group_in_namespace.name,
                        project=project_name,
                        user=gitlab_user,
                    )
                    sys.exit(1)
        else:
            found_projects = createproject(
                gitlab_connection,
                project_name,
                group_in_namespace,
                args.visibility,
                args.desc,
                args.issues,
                args.wall,
                args.merge,
                args.wiki,
                args.snippets,
            )
            if not found_projects:
                logging.error(
                    "There was a problem creating %s/%s.  Did you give %s user Admin rights in gitlab?",
                    group=gitlab_toplevel_group,
                    project=project_name,
                    user=gitlab_user,
                )
                sys.exit(1)
        print(found_projects.http_url_to_repo if args.http else found_projects.ssh_url_to_repo)
    elif args.delete:
        if not found_projects:
            logging.error("Project %s not found in %s", proj_name_args, gitlab_url)
        try:
            deleted_project = found_projects.delete()
        except Exception as e:
            logging.error(str(e))
            sys.exit(1)
    else:
        logging.error("No --create or --delete option added.")
        sys.exit(1)
