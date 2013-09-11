#!/usr/bin/env python

from sys import argv,exit
import os
import gitlab

try:
  project_name=argv[1]
  token_secret=os.environ['token_secret']
  gitlab_url=os.environ['gitlab_url']
  gitlab_namespace=os.environ['gitlab_namespace']
except KeyError:
  print "Environment config missing.  Do not run this script standalone."
  exit(1)
except IndexError:
  print "No project name specified.  Do not run this script standalone."
  exit(1)

git=gitlab.Gitlab(gitlab_url,token_secret)

#Locate the group
found_group=False
for group in git.getGroups():
  if group['name'] == gitlab_namespace:
    found_group=group
    break
else:
  if not found_group:
    print "Project namespace (user or group) not found or user does not have permission of existing group."
    exit(1)

#Locate existing repository, if it doesn't exist then create it in gitlab
found_project=False
for project in git.getProjects():
  if project['namespace']['name'] == gitlab_namespace and project['name'] == project_name:
    found_project=project
    break
if not found_project:
  print "not found"
  pass

print found_project['http_url_to_repo']
