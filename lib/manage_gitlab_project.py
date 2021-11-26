#!/usr/bin/env python
#Created by Sam Gleske
#MIT License
#Created Tue Sep 10 23:01:08 EDT 2013

from sys import argv,exit,stderr
from optparse import OptionParser
import os

try:
  import gitlab
except ImportError:
  raise ImportError("python-gitlab module is not installed.  You probably didn't read the install instructions closely enough.  See docs/prerequisites.md.")

def printErr(message):
  stderr.write(message + "\n")
  stderr.flush()

try:
  token_secret=os.environ['gitlab_user_token_secret']
  gitlab_url=os.environ['gitlab_url']
  gitlab_namespace=os.environ['gitlab_namespace']
  gitlab_user=os.environ['gitlab_user']
  ssl_verify=os.environ['ssl_verify']
  gitlab_api_version=os.environ['gitlab_api_version']
except KeyError:
  printErr("Environment config missing.  Do not run this script standalone.")
  exit(1)
parser = OptionParser()
parser.add_option("--issues",dest="issues",action="store_true",default=False)
parser.add_option("--wall",dest="wall",action="store_true",default=False)
parser.add_option("--merge",dest="merge",action="store_true",default=False)
parser.add_option("--wiki",dest="wiki",action="store_true",default=False)
parser.add_option("--snippets",dest="snippets",action="store_true",default=False)
parser.add_option("--public",dest="public",action="store_true",default=False)
parser.add_option("--create",dest="create",action="store_true",default=False)
parser.add_option("--delete",dest="delete",action="store_true",default=False)
parser.add_option("--desc",dest="desc",metavar="DESC",default=False)
parser.add_option("--http",dest="http",action="store_true",default=False)
(options,args) = parser.parse_args()
if len(args) == 0:
  printErr("No project name specified.  Do not run this script standalone.")
  exit(1)
elif len(args) > 1:
  printErr("Too many arguments.  Do not run this script standalone.")
  exit(1)

project_name=args[0]

if not eval(ssl_verify.capitalize()):
  git=gitlab.Gitlab(gitlab_url,token_secret,ssl_verify=False,api_version=gitlab_api_version)
else:
  git=gitlab.Gitlab(gitlab_url,token_secret,ssl_verify=True,api_version=gitlab_api_version)

def find_group(**kwargs):
  groups = git.groups.list(all_available=False)
  return _find_matches(groups, kwargs, False)

def find_project(**kwargs):
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
def transfer_project(src_project, group):
  value = group.transfer_project(src_project.id)
  dest_project = find_project(name=src_project.name)
  return dest_project

def createproject(pname):
  if options.public:
     visibility_level="public"
  else:
     visibility_level="private"
  if len(options.desc) == 0:
    if options.public:
      description="Public mirror of %s." % project_name
    else:
      description="Git mirror of %s." % project_name
  else:
    description=options.desc
  project_options={
    'issues_enabled': options.issues,
    'wall_enabled': options.wall,
    'merge_requests_enabled': options.merge,
    'wiki_enabled': options.wiki,
    'snippets_enabled': options.snippets,
    'visibility': visibility_level,
    'namespace_id': find_group(name=gitlab_namespace).id,
  }
  #make all project options lowercase boolean strings i.e. true instead of True
  for x in project_options.keys():
    project_options[x] = str(project_options[x]).lower()
  printErr("Creating new project %s" % pname)
  project_options['name'] = pname
  project_options['description'] = description
  git.projects.create(project_options)
  found_project = find_project(name=pname)
  if needs_transfer(gitlab_user, gitlab_namespace, found_project):
     found_project = transfer_project(found_project, found_group)
  return found_project

# returns a Bool True if the transfer is required
def needs_transfer(user, groupname, project):
  namespace = False
  if groupname:
    namespace = groupname
  else:
    namespace = user
  if type(project.namespace) == gitlab.v4.objects.Group:
    return project.namespace.name != namespace
  else:
    return project.namespace['name'] != namespace

if options.create:
  found_group = find_group(name=gitlab_namespace)
  found_project = None

  found_project= find_project(name=project_name)
  #exit()
  if found_project:
    if needs_transfer(gitlab_user, gitlab_namespace, found_project):
      found_project = transfer_project(found_project, found_group)
      if not found_project:
        printErr("There was a problem transferring {group}/{project}.  Did you give {user} user Admin rights in gitlab?".format(group=gitlab_namespace,project=project_name,user=gitlab_user))
        exit(1)
  else:
    found_project=createproject(project_name)
    if not found_project:
      printErr("There was a problem creating {group}/{project}.  Did you give {user} user Admin rights in gitlab?".format(group=gitlab_namespace,project=project_name,user=gitlab_user))
      exit(1)
  if options.http:
    print(found_project.http_url_to_repo)
  else:
    print(found_project.ssh_url_to_repo)
elif options.delete:
  try:
    deleted_project=find_project(name=project_name).delete()
  except Exception as e:
    printErr(e)
    exit(1)
else:
  printErr("No --create or --delete option added.")
  exit(1)
