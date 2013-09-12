#!/usr/bin/env python
#Tue Sep 10 23:01:08 EDT 2013

from sys import argv,exit,stderr
from optparse import OptionParser
import os
import gitlab



try:
  token_secret=os.environ['gitlab_user_token_secret']
  gitlab_url=os.environ['gitlab_url']
  gitlab_namespace=os.environ['gitlab_namespace']
  gitlab_user=os.environ['gitlab_user']
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
(options,args) = parser.parse_args()
if len(args) == 0:
  print >> stderr, "No project name specified.  Do not run this script standalone."
  exit(1)
elif len(args) > 1:
  print >> stderr, "Too many arguments.  Do not run this script standalone."
  exit(1)

project_name=args[0]

git=gitlab.Gitlab(gitlab_url,token_secret,version=6)

def findgroup(gname):
  #Locate the group
  found_group=False
  for group in git.getGroups():
    if group['name'] == gname:
      return group
  else:
    if not found_group:
      print >> stderr, "Project namespace (user or group) not found or user does not have permission of existing group."
      exit(1)

def findproject(gname,pname):
  for project in git.getProjects():
    if project['namespace']['name'] == gname and project['name'] == pname:
      return project
  else:
    return False

def createproject(pname):
  if options.public:
    description="Public mirror of %s." % project_name
  else:
    description="Git mirror of %s." % project_name
  new_project=git.createProject(pname,description=description,issues_enabled=options.issues,wall_enabled=options.wall,merge_requests_enabled=options.merge,wiki_enabled=options.wiki,snippets_enabled=options.snippets,public=options.public)
  new_project=findproject(gitlab_user,pname)
  new_project=git.moveProject(found_group['id'],new_project['id'])
  if findproject(gitlab_namespace,pname):
    return findproject(gitlab_namespace,pname)
  else:
    return False

if options.create:
  found_group=findgroup(gitlab_namespace)
  found_project=findproject(gitlab_namespace,project_name)

  if not found_project:
    found_project=createproject(project_name)
    if not found_project:
      print >> stderr, "There was a problem creating {group}/{project}.  Did you give {user} user Admin rights in gitlab?".format(group=gitlab_namespace,project=project_name,user=gitlab_user)
      exit(1)

  print found_project['ssh_url_to_repo']
