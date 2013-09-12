#!/bin/bash
#Tue Sep 10 23:01:08 EDT 2013
#USAGE
#  ./add_mirror.sh project_name http://example.com/project.git

#Include all user options
. "$(dirname $0)/config.sh"
cd $(dirname $0)

PROGNAME="${0##*/}"
PROGVERSION="v0.2"


#Default script options
svn=false
git=false
project_name=""
mirror=""

#Short options are one letter.  If an argument follows a short opt then put a colon (:) after it
SHORTOPTS="hvm:p:"
LONGOPTS="help,version,git,svn,mirror:,project:"

usage()
{
  cat <<EOF
${PROGNAME} ${PROGVERSION} - MIT License by Sam Gleske

DESCRIPTION:
  This will add a git or SVN repository to be mirrored by GitLab.  It 
  first checks to see if the project exists in gitlab.  If it does
  not exist then it creates it.  It will then clone and check in the
  first copy into GitLab.  From there you must use the update_mirror.sh
  script or git git-mirrors.sh script.

  -h,--help          Show help
  -v,--version       Show program version
  --git              Mirror a git repository (must be explicitly set)
  --svn              Mirror a SVN repository (must be explicitly set)
  --project NAME     Set a GitLab project name to NAME.
  --mirror URL       Repository URL to be mirrored.


EOF
}

ARGS=$(getopt -s bash --options "${SHORTOPTS}" --longoptions "${LONGOPTS}" --name "${PROGNAME}" -- "$@")
eval set -- "$ARGS"
echo "$ARGS"
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
    --git)
        git=true
        shift
      ;;
    --svn)
        svn=true
        shift
      ;;
    -p|--project)
        project_name="${2}"
        shift 2
      ;;
    -m|--mirror)
        mirror="${2}"
        shift 2
      ;;
    --)
        shift
        break
      ;;
    *)
        shift
        break
      ;;
    esac
done


echo "svn=${svn}"
echo "git=${git}"
echo "project_name=${project_name}"
echo "mirror=${mirror}"














exit

if [ "${#}" -lt "2" ];then
  echo "Not enough arguments." 1>&2
  echo "e.g. ./add_mirror.sh project_name http://example.com/project.git" 1>&2
  exit 1
fi


#export env vars for python script
export gitlab_user_token_secret gitlab_url gitlab_namespace gitlab_user

#Get the remote gitlab url for the specified project.
#If the project doesn't already exist in gitlab then create it.
echo "Resolving gitlab remote."
if python lib/create_gitlab_project.py $1 1> /dev/null;then
  gitlab_remote=$(python lib/create_gitlab_project.py $1)
  echo "gitlab remote ${gitlab_remote}"
else
  echo "There was an unknown issue with create_gitlab_project.py" 1>&2
  exit 1
fi

mkdir -p "${repo_dir}/${gitlab_namespace}"

#create a mirror
echo "Creating mirror from $2"
cd "${repo_dir}/${gitlab_namespace}"
git clone --mirror $2 "$1"
cd "$1"
#add the gitlab remote
echo "Adding gitlab remote to project."
git remote add gitlab ${gitlab_remote}
git config --add remote.gitlab.push '+refs/heads/*:refs/heads/*'
git config --add remote.gitlab.push '+refs/heads/*:refs/heads/*'
#Check the initial repository into gitlab
echo "Checking the mirror into gitlab."
git fetch
git remote prune origin
git push gitlab
echo "All done!"
