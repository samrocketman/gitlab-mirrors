#!/usr/bin/env python
#Tue Sep 10 23:01:08 EDT 2013

from sys import argv,exit,stderr
import os
import gitlab

try:
  project_name=argv[1]
  token_secret=os.environ['token_secret']
  gitlab_url=os.environ['gitlab_url']
  gitlab_namespace=os.environ['gitlab_namespace']
  gitlab_user=os.environ['gitlab_user']
except KeyError:
  print "Environment config missing.  Do not run this script standalone."
  exit(1)
except IndexError:
  print "No project name specified.  Do not run this script standalone."
  exit(1)

git=gitlab.Gitlab(gitlab_url,token_secret)

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
  description="Public mirror of %s." % project_name
  new_project=git.createProject(pname,description=description,issues_enabled=False,wall_enabled=False,merge_requests_enabled=False,wiki_enabled=False,snippets_enabled=False)
  new_project=findproject(gitlab_user,pname)
  new_project=git.moveProject(found_group['id'],new_project['id'])
  if findproject(gitlab_namespace,pname):
    return findproject(gitlab_namespace,pname)
  else:
    return False

found_group=findgroup(gitlab_namespace)
found_project=findproject(gitlab_namespace,project_name)

if not found_project:
  found_project=createproject(project_name)
  if not found_project:
    #print >> stderr, "There was a problem creating %s/%s.  Did you give %s user Admin rights in gitlab?" % {gitlab_namespace,project_name,gitlab_user}
    print >> stderr, "There was a problem creating {group}/{project}.  Did you give {user} user Admin rights in gitlab?".format(group=gitlab_namespace,project=project_name,user=gitlab_user)
    exit(1)

print found_project['ssh_url_to_repo']
