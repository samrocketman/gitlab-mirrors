#!/bin/bash
#Created by Sam Gleske
#MIT License
#Created Sat Sep 14 15:50:13 EDT 2013
#USAGE
#  ./list-mirrors.sh

#bash option stop on first error
set -eu

#Include all user options and dependencies
git_mirrors_dir="${0%/*}"
source "${git_mirrors_dir}"/includes.sh

if [ ! -d "${repo_dir}/${gitlab_namespace}" ];then 
  exit 0
fi

pushd "${repo_dir}/${gitlab_namespace}" &> /dev/null
echo -n "Namespace: " 1>&2
#red and bold combined
red_echo "$(bold_echo -n "${gitlab_namespace}")" 1>&2
ls -1 "${repo_dir}/${gitlab_namespace}" | while read mirror;do
  pushd "${mirror}" &> /dev/null
  if git config --get svn-remote.svn.url &> /dev/null;then
    repo="$(git config --get svn-remote.svn.url)"
  else
    repo="$(git config --get remote.origin.url)"
  fi
  green_echo -n "${mirror}"
  echo -n " -> "
  yellow_echo "${repo}"
  popd &> /dev/null
done
popd &> /dev/null

