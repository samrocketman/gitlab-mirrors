#!/bin/bash
#Tue Sep 10 23:01:08 EDT 2013

#Include all user options
. "$(dirname $0)/config.sh"
cd $(dirname $0)

STATUS=0

ls -1 "${repo_dir}/${gitlab_namespace}" | while read mirror;do
  if ! ./update_mirror.sh "${mirror}" &> /dev/null;then
    echo "Error: ./update_mirror.sh ${mirror}" 1>&2
    STATUS=1
  fi
done
exit ${STATUS}
