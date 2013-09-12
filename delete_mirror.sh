#!/bin/bash
#Thu Sep 12 16:04:35 EDT 2013

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
quiet=false

#
# ARGUMENT HANDLING
#

usage()
{
  cat <<EOF
${PROGNAME} ${PROGVERSION} - MIT License by Sam Gleske

USAGE:
  ${PROGNAME} --delete PROJECT

DESCRIPTION:
  This program deletes a project so that it will no longer be mirrored.

  -h,--help          Show help
  -v,--version       Show program version
  -d,--delete PROJECT
                     Deletes a project so it is no longer mirrored.
  -q,--quiet         Suppress user confirmation messages.


EOF
}
#Short options are one letter.  If an argument follows a short opt then put a colon (:) after it
SHORTOPTS="hvd:q"
LONGOPTS="help,version,delete:,quiet"
ARGS=$(getopt -s bash --options "${SHORTOPTS}" --longoptions "${LONGOPTS}" --name "${PROGNAME}" -- "$@")
eval set -- "$ARGS"
while true; do
  case $1 in
    -h|--help)
        usage
        exit 1
      ;;
    -v|--version)
        echo "${PROGNAME} ${PROGVERSION}"
        exit 1
      ;;
    -d|--delete)
        project_name="${2}"
        shift 2
      ;;
    -q|--quiet)
        quiet=true
        shift
      ;;
    --)
        shift
        break
      ;;
    *)
        shift
      ;;
    esac
done

#
# Program functions
#

function preflight() {
  STATUS=0
  if [ -z "${project_name}" ];then
    red_echo -n "Must specify " 1>&2
    yellow_echo -n "--delete" 1>&2
    red_echo " option." 1>&2
    STATUS=1
  fi
  return ${STATUS}
}

#
# Main execution
#

#Run a preflight check on options for compatibility.
if ! preflight;then
  echo "Command aborted due to previous errors." 1>&2
  exit 1
fi

if ! ${quiet};then
  echo -n "Will DELETE "
  red_echo "${repo_dir}/${gitlab_namespace}/${project_name}"
  echo
  echo -n "Are you sure you wish to delete project "
  yellow_echo -n "${gitlab_namespace}/${project_name}"
  echo -n "? (y/N): "
  read ans
  echo
  #convert upper case to lower case
  ans="$(echo "${ans}" | tr '[A-Z]' '[a-z]')"
  if [ ! "${ans}" = "y" -a ! "${ans}" = "yes" ];then
    echo "User aborted operation." 1>&2
    exit 1
  fi
fi

rm -rf "${repo_dir}/${gitlab_namespace}/${project_name}"
green_echo -n "DELETED"
echo " ${repo_dir}/${gitlab_namespace}/${project_name}"
echo
yellow_echo -n "**NOTE**:"
echo " You must log into the GitLab web interface in order to delete the project from GitLab!"
