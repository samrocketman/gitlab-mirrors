#!/usr/bin/env python3
# Created by Sam Gleske
# MIT License
# Created Tue Sep 10 23:01:08 EDT 2013

import logging
import sys
import argparse
import os

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
    gitlab_namespace = os.environ["gitlab_namespace"]
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
    p.add_argument("--public", dest="public", action="store_true", default=False)
    p.add_argument("--create", dest="create", action="store_true", default=False)
    p.add_argument("--delete", dest="delete", action="store_true", default=False)
    p.add_argument("--desc", dest="desc", default="")
    p.add_argument("--http", dest="http", action="store_true", default=False)

    return p


def find_group(git, **kwargs) -> list[Group]:
    groups = git.groups.list(all_available=False)
    return _find_matches(groups, kwargs, False)


def find_project(git, **kwargs) -> list[Project]:
    projects = git.projects.list(as_list=True)
    return _find_matches(projects, kwargs, False)


def _find_matches(objects, kwargs, find_all):
    """Helper function for _add_find_fn. Find objects whose properties
    match all key, value pairs in kwargs.
    Source: https://github.com/doctormo/python-gitlab3/blob/master/gitlab3/__init__.py
    """
    ret = []
    for obj in objects:
        match = True
        # Match all supplied parameters
        for param, val in kwargs.items():
            if not getattr(obj, param) == val:
                match = False
                break
            if match:
                if find_all:
                    ret.append(obj)
                else:
                    return obj
    if not find_all:
        return None
    return ret


# transfer the project from the source namespace to the specified group namespace
def transfer_project(git, src_project: Project, group: Group) -> Project:
    group.transfer_project(src_project.id)
    dest_project = find_project(git, name=src_project.name)
    return dest_project


def createproject(
    git: gitlab.Gitlab,
    pn: str,
    found_group: Group,
    public: bool,
    desc: str,
    issues: bool,
    wall: bool,
    merge: bool,
    wiki: bool,
    snippets: bool,
):
    visibility_level = "public" if public else "private"

    project_options = {
        "issues_enabled": issues,
        "wall_enabled": wall,
        "merge_requests_enabled": merge,
        "wiki_enabled": wiki,
        "snippets_enabled": snippets,
        "visibility": visibility_level,
        "namespace_id": found_group.id,
    }
    # make all project options lowercase boolean strings i.e. true instead of True
    for x in project_options.keys():
        project_options[x] = str(project_options[x]).lower()
    logging.info("Creating new project %s", pn)
    project_options["name"] = pn
    project_options["description"] = desc if desc else f"Public mirror of {pn}." if public else f"Git mirror of {pn}."
    git.projects.create(project_options)
    project_for_transfer = find_project(git, name=pn)
    if needs_transfer(gitlab_user, gitlab_namespace, project_for_transfer):
        project_for_transfer = transfer_project(git, project_for_transfer, found_group)
    return project_for_transfer


# returns a Bool True if the transfer is required
def needs_transfer(user, groupname: Project, project: Project):
    namespace = False
    if groupname:
        namespace = groupname
    else:
        namespace = user
    if isinstance(project.namespace, Group):
        return project.namespace.name != namespace
    return project.namespace["name"] != namespace


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

    if args.create:
        group_in_namespace = find_group(gitlab_connection, name=gitlab_namespace)
        logging.debug("Found groups %s", group_in_namespace)

        found_projects = find_project(gitlab_connection, name=args.projectname)
        logging.debug("Found projects %s", found_projects)
        if found_projects:
            if needs_transfer(gitlab_user, gitlab_namespace, found_projects):
                found_projects = transfer_project(
                    gitlab_connection, found_projects, group_in_namespace
                )
                if not found_projects:
                    logging.error(
                        "There was a problem transferring %s/%s.  Did you give %s user Admin rights in gitlab?",
                        group=gitlab_namespace,
                        project=args.projectname,
                        user=gitlab_user,
                    )
                    sys.exit(1)
        else:
            found_projects = createproject(
                gitlab_connection,
                args.projectname,
                group_in_namespace,
                args.public,
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
                    group=gitlab_namespace,
                    project=args.projectname,
                    user=gitlab_user,
                )
                sys.exit(1)
        print(found_projects.http_url_to_repo if args.http else found_projects.ssh_url_to_repo)
    elif args.delete:
        try:
            deleted_project = find_project(gitlab_connection, name=args.projectname).delete()
        except Exception as e:
            logging.error(str(e))
            sys.exit(1)
    else:
        logging.error("No --create or --delete option added.")
        sys.exit(1)
