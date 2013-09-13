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
project_name=""

if [ -z "$1" ];then
  echo "Must specify a project_name!" 1>&2
  exit 1
elif [ ! -d "${repo_dir}/${gitlab_namespace}/$1" ];then
  echo "No git repository for $1!  Perhaps run add_mirror.sh?" 1>&2
  exit 1
fi

cd "${repo_dir}/${gitlab_namespace}/$1"
git fetch
git remote prune origin
git push gitlab
