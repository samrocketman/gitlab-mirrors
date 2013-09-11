#!/bin/bash
#Tue Sep 10 23:01:08 EDT 2013
#USAGE
#  ./update_mirror.sh project_name


#Include all user options
. "$(dirname $0)/config.sh"
cd $(dirname $0)

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
