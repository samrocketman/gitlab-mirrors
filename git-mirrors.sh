#!/bin/bash
#Created by Sam Gleske
#MIT License
#Created Tue Sep 10 23:01:08 EDT 2013

set -u
[[ -n $DEBUG ]] && set -x

#Include all user options and dependencies
git_mirrors_dir="${0%/*}"
source "${git_mirrors_dir}/includes.sh"

cd "${git_mirrors_dir}" || exit

STATUS=0

for mirror in $(find "${repo_dir}/${gitlab_namespace}" -name refs -type d ); do
  mirror=$(realpath -s --relative-to="${repo_dir}/${gitlab_namespace}" $mirror/..)
  echo "$(date +'%Y-%m-%d %H:%M:%S') CRON Startup for ${mirror}" >> ${git_mirrors_dir}/cron.log
  if ! ./update-mirror.sh "${mirror}" >> ${git_mirrors_dir}/cron.log 2>&1 ;then
    red_echo "Error: ./update-mirror.sh ${mirror} (more information in ${git_mirrors_dir}/cron.log)" 1>&2
    STATUS=1
  fi
done

if [[ -n $DEBUG ]];then 
  cat "${git_mirrors_dir}"/cron.log
fi

exit ${STATUS}
