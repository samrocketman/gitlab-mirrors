#!/bin/bash
#Created by Sam Gleske
#MIT License
#Created Tue Sep 10 23:01:08 EDT 2013

#Include all user options and dependencies
git_mirrors_dir="${0%/*}"
[ -f "${git_mirrors_dir}/config.sh" ] && . "${git_mirrors_dir}/config.sh"
. "${git_mirrors_dir}/lib/VERSION"
. "${git_mirrors_dir}/lib/functions.sh"
if [ ! -f "${git_mirrors_dir}/config.sh" ];then
  red_echo "config.sh missing!  Copy and customize from config.sh.SAMPLE.  Aborting." 1>&2
  exit 1
fi

cd "${git_mirrors_dir}"

STATUS=0

ls -1 "${repo_dir}/${gitlab_namespace}" | while read mirror;do
  if ! ./update_mirror.sh "${mirror}" >> ${git_mirrors_dir}/cron.log 2>&1 ;then
    red_echo "Error: ./update_mirror.sh ${mirror} (more information in ${git_mirrors_dir}/cron.log)" 1>&2
    STATUS=1
  fi
done
exit ${STATUS}
