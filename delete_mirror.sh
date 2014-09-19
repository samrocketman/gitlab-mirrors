#!/bin/bash
#Created by Sam Gleske
#MIT License
#Created Thu Sep 12 16:04:35 EDT 2013

#bash option stop on first error
set -e

#Include all user options and dependencies
git_mirrors_dir="${0%/*}"
[ -f "${git_mirrors_dir}/config.sh" ] && . "${git_mirrors_dir}/config.sh"
. "${git_mirrors_dir}/lib/VERSION"
. "${git_mirrors_dir}/lib/functions.sh"
if [ ! -f "${git_mirrors_dir}/config.sh" ];then
  red_echo "config.sh missing!  Copy and customize from config.sh.SAMPLE.  Aborting." 1>&2
  exit 1
fi

#export env vars for python script
export gitlab_user_token_secret gitlab_url gitlab_namespace gitlab_user ssl_verify

cd "${git_mirrors_dir}"

PROGNAME="${0##*/}"
PROGVERSION="${VERSION}"

#Default script options
project_name=""
quiet=false
no_delete=false

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
  -n,--no-delete PROJECT
                     Only deletes the local project but not the remote.
                     This option is forced for projects with
                     --no-create set when the mirror was added.
  -q,--quiet         Suppress user confirmation messages.


EOF
}
#Short options are one letter.  If an argument follows a short opt then put a colon (:) after it
SHORTOPTS="hvd:n:q"
LONGOPTS="help,version,delete:,no-delete:,quiet"
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
    -n|--no-delete)
        project_name="${2}"
        no_delete=true
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
    red_echo -n "Must specify "
    yellow_echo -n "--delete"
    red_echo -n " or "
    yellow_echo -n "--no-delete"
    red_echo " option."
    STATUS=1
  elif [ ! -e "${repo_dir}/${gitlab_namespace}/${project_name}" ];then
    yellow_echo -n "${repo_dir}/${gitlab_namespace}/${project_name}" 1>&2
    echo " does not exist."
    STATUS=1
  fi
  return ${STATUS}
}

#
# Main execution
#

#Run a preflight check on options for compatibility.
if ! preflight 1>&2;then
  echo "Command aborted due to previous errors." 1>&2
  exit 1
fi

if ! ${quiet};then
  echo -n "Will DELETE "
  red_echo "${repo_dir}/${gitlab_namespace}/${project_name}"
  echo
  red_echo "This action CANNOT be undone!"
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

pushd "${repo_dir}/${gitlab_namespace}/${project_name}" &> /dev/null
if git config --get gitlabmirrors.nocreate &> /dev/null && [ "$(git config --get gitlabmirrors.nocreate)" = "true" ];then
  no_delete=true
fi
if git config --get gitlabmirrors.noremote &> /dev/null && [ "$(git config --get gitlabmirrors.noremote)" = "true" ];then
  no_remote_set=true
fi
popd &> /dev/null

rm -rf "${repo_dir}/${gitlab_namespace}/${project_name}"
green_echo -n "DELETED" 1>&2
echo " ${repo_dir}/${gitlab_namespace}/${project_name}" 1>&2
if ! ${no_remote_set};then
  if ! ${no_delete};then
    if ! python lib/manage_gitlab_project.py --delete "${project_name}";then
      red_echo "There was an unknown issue with manage_gitlab_project.py" 1>&2
      exit 1
    fi
    green_echo -n "DELETED" 1>&2
    echo " ${gitlab_namespace}/${project_name} from GitLab" 1>&2
  else
    echo 1>&2
    yellow_echo -n "**NOTE**:" 1>&2
    echo " You must log into the GitLab web interface in order to delete the project from GitLab!" 1>&2
  fi
fi
