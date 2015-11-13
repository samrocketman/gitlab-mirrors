#!/usr/bin/env python
#Created by Sam Gleske
#MIT License
#Created Tue Sep 10 23:01:08 EDT 2013

from sys import argv,exit,stderr
from optparse import OptionParser
import os
try:
  import gitlab3 as gitlab
except ImportError:
  raise ImportError("python-gitlab3 module is not installed.  You probably didn't read the install instructions closely enough.  See docs/prerequisites.md.")



try:
  token_secret=os.environ['gitlab_user_token_secret']
  gitlab_url=os.environ['gitlab_url']
  gitlab_namespace=os.environ['gitlab_namespace']
  gitlab_user=os.environ['gitlab_user']
  ssl_verify=os.environ['ssl_verify']
except KeyError:
  print >> stderr, "Environment config missing.  Do not run this script standalone."
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
  print >> stderr, "No project name specified.  Do not run this script standalone."
  exit(1)
elif len(args) > 1:
  print >> stderr, "Too many arguments.  Do not run this script standalone."
  exit(1)

project_name=args[0]

if not eval(ssl_verify.capitalize()):
  git=gitlab.GitLab(gitlab_url=gitlab_url,token=token_secret,ssl_verify=False)
else:
  git=gitlab.GitLab(gitlab_url=gitlab_url,token=token_secret,ssl_verify=True)

# transfer the project from the source namespace to the specified group namespace
def transfer_project(src_project, group):
  value = group.transfer_project(src_project.id)
  dest_project = git.find_project(name=src_project.name)
  return dest_project

def createproject(pname):
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
    'public': options.public,
    'namespace_id': git.find_group(name=gitlab_namespace).id,
  }
  #make all project options lowercase boolean strings i.e. true instead of True
  for x in project_options.keys():
    project_options[x] = str(project_options[x]).lower()
  print >> stderr, "Creating new project %s" % pname
  git.add_project(pname,description=description,**project_options)
  found_project = git.find_project(name=pname)
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
  return project.namespace['name'] != namespace

if options.create:
  found_group=git.find_group(name=gitlab_namespace)
  found_project = None
  # search the group namespace first
  found_project=git.find_project(name=project_name)
  if found_project:
    if needs_transfer(gitlab_user, gitlab_namespace, found_project):
      found_project = transfer_project(found_project, found_group)
      if not found_project:
        print >> stderr, "There was a problem transferring {group}/{project}.  Did you give {user} user Admin rights in gitlab?".format(group=gitlab_namespace,project=project_name,user=gitlab_user)
        exit(1)
  else:
    found_project=createproject(project_name)
    if not found_project:
      print >> stderr, "There was a problem creating {group}/{project}.  Did you give {user} user Admin rights in gitlab?".format(group=gitlab_namespace,project=project_name,user=gitlab_user)
      exit(1)
  if options.http:
    print found_project.http_url_to_repo
  else:
    print found_project.ssh_url_to_repo
elif options.delete:
  try:
    deleted_project=git.find_project(name=project_name).delete()
  except Exception as e:
    print >> stderr, e
    exit(1)
else:
  print >> stderr, "No --create or --delete option added."
  exit(1)
                        
