#!/bin/bash
#Created by Sam Gleske
#MIT License
#Created Tue Sep 10 23:01:08 EDT 2013
#USAGE
#  ./update_mirror.sh project_name

#bash option stop on first error
set -e

#Include all user options and dependencies
git_mirrors_dir="$(dirname "${0}")"
cd "${git_mirrors_dir}"
. "config.sh"
. "lib/VERSION"
. "lib/functions.sh"

PROGNAME="${0##*/}"
PROGVERSION="${VERSION}"

#Default script options
project_name="$1"

if [ -z "${project_name}" ];then
  echo "Must specify a project_name!" 1>&2
  exit 1
elif [ ! -d "${repo_dir}/${gitlab_namespace}/${project_name}" ];then
  echo "No git repository for $1!  Perhaps run add_mirror.sh?" 1>&2
  exit 1
fi

cd "${repo_dir}/${gitlab_namespace}/${project_name}"
if git config --get svn-remote.svn.url &> /dev/null;then
  #this is an SVN mirror so update it accordingly
  git reset --hard
  git svn fetch
  git svn rebase
  cd .git
  git config --bool core.bare true
  #bug fix for when gitlab is off-line during a cron job the bare setting gets set back to false when the git command fails
  set +e
  if ! git push gitlab;then
    git config --bool core.bare false
    exit 1
  fi
  set -e
  git config --bool core.bare false
else
  #just a git mirror so mirror it accordingly
  git fetch
  git remote prune origin
  git push gitlab
fi
