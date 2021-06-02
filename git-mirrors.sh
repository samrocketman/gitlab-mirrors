#!/bin/bash
#Created by Sam Gleske
#MIT License
#Created Tue Sep 10 23:01:08 EDT 2013

#Include all user options and dependencies
git_mirrors_dir="${0%/*}"
source ${git_mirrors_dir}/includes.sh

cd "${git_mirrors_dir}"

STATUS=0

while read mirror
do
  echo "$(date +'%Y-%m-%d %H:%M:%S') CRON Startup for ${mirror}" >> ${git_mirrors_dir}/cron.log
  if ! ./update_mirror.sh "${mirror}" >> ${git_mirrors_dir}/cron.log 2>&1 ;then
    red_echo "Error: ./update_mirror.sh ${mirror} (more information in ${git_mirrors_dir}/cron.log)" 1>&2
    STATUS=1
  fi
done <<< "$(ls -1 "${repo_dir}/${gitlab_namespace}")"

exit ${STATUS}
