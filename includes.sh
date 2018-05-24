#!/bin/bash -e

#Include all user options and dependencies
git_mirrors_dir="${0%/*}"
[ -f "${git_mirrors_dir}/config.sh" ] && . "${git_mirrors_dir}/config.sh"
. "${git_mirrors_dir}/lib/VERSION"
. "${git_mirrors_dir}/lib/functions.sh"
if [ ! -f "${git_mirrors_dir}/config.sh" ];then
  red_echo "config.sh missing!  Copy and customize from config.sh.SAMPLE.  Aborting." 1>&2
  exit 1
fi
