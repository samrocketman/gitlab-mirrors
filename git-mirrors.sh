#!/bin/bash
#Created by Sam Gleske
#MIT License
#Created Tue Sep 10 23:01:08 EDT 2013

#Include all user options and dependencies
git_mirrors_dir="$(dirname "${0}")"
. "${git_mirrors_dir}/config.sh"
. "${git_mirrors_dir}/lib/VERSION"
. "${git_mirrors_dir}/lib/functions.sh"

STATUS=0

ls -1 "${repo_dir}/${gitlab_namespace}" | while read mirror;do
  if ! ./update_mirror.sh "${mirror}" &> /dev/null;then
    red_echo "Error: ./update_mirror.sh ${mirror}" 1>&2
    STATUS=1
  fi
done
exit ${STATUS}
