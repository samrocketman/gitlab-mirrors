#!/bin/bash
#Created by Sam Gleske
#MIT License
#Created Tue Sep 10 23:01:08 EDT 2013
#USAGE
#  ./update_mirror.sh project_name

#bash option stop on first error
set -eu

#Include all user options and dependencies
git_mirrors_dir="${0%/*}"
source ${git_mirrors_dir}/includes.sh

#sane update defaults that are backwards compatible
force_update="${force_update:-false}"
prune_mirrors="${prune_mirrors:-false}"

#test force_update environment variable (must be bool)
if [ ! "${force_update}" = "true" ] && [ ! "${force_update}" = "false" ];then
  red_echo -n "force_update="
  yellow_echo -n "${force_update}"
  red_echo -n " is not a valid option for force_update!  Must be "
  yellow_echo -n "true"
  red_echo -n " or "
  yellow_echo -n "false"
  red_echo "."
  exit 1
fi
#test prune_mirrors environment variable (must be bool)
if [ ! "${prune_mirrors}" = "true" ] && [ ! "${prune_mirrors}" = "false" ];then
  red_echo -n "prune_mirrors="
  yellow_echo -n "${prune_mirrors}"
  red_echo -n " is not a valid option for prune_mirrors!  Must be "
  yellow_echo -n "true"
  red_echo -n " or "
  yellow_echo -n "false"
  red_echo "."
  exit 1
fi

cd "${git_mirrors_dir}"

#Default script options
project_name="${1}"

if [ -z "${project_name}" ];then
  echo "Must specify a project_name!" 1>&2
  exit 1
elif [ ! -d "${repo_dir}/${gitlab_namespace}/${project_name}" ];then
  echo "No git repository for ${1}!  Perhaps run add_mirror.sh?" 1>&2
  exit 1
fi

cd "${repo_dir}/${gitlab_namespace}/${project_name}"
#check for local only repository type
if git config --get gitlabmirrors.noremote &> /dev/null && [ "$(git config --get gitlabmirrors.noremote)" = "true" ];then
  no_remote_set=true
fi
if git config --get svn-remote.svn.url &> /dev/null;then
  #this is an SVN mirror so update it accordingly
  if [ "$(git config --get core.bare)" = "true" ];then
    git config --bool core.bare false
  fi
  git reset --hard
  git svn fetch
  git svn rebase

  if ! ${no_remote_set};then
    #push to the remote
    cd .git
    git config --bool core.bare true
    #bug fix for when gitlab is off-line during a cron job the bare setting gets
    #set back to false when the git command fails
    git push gitlab
    git config --bool core.bare false
  fi
else
  #just a git mirror so mirror it accordingly
  git_args=()
  if ${force_update};then
    git_args+=("--force")
  fi
  if ${prune_mirrors};then
    git_args=("--prune")
  fi
  git fetch "${git_args[@]}" origin

  if ! ${no_remote_set};then
    #push to the remote
    git push "${git_args[@]}" gitlab
  fi
fi
