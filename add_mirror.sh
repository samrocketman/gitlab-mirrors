#!/bin/bash
#Tue Sep 10 23:01:08 EDT 2013
#USAGE
#  ./add_mirror.sh project_name http://example.com/project.git


#Include all user options
. "$(dirname $0)/config.sh"
cd $(dirname $0)

export token_secret gitlab_url gitlab_namespace gitlab_user

#Get the remote gitlab url for the specified project.
#If the project doesn't already exist in gitlab then create it.
if python lib/create_gitlab_project.py $1 &> /dev/null;then
  gitlab_remote=$(python lib/create_gitlab_project.py $1)
else
  echo "There was an unknown issue with create_gitlab_project.py" 1>&2
  exit 1
fi

mkdir -p "${repo_dir}/${gitlab_namespace}"

#create a mirror
cd "${repo_dir}/${gitlab_namespace}"
git clone --mirror $2 "$1"
cd "$1"
#add the gitlab remote
git remote add gitlab ${gitlab_remote}
git config --add remote.gitlab.push '+refs/heads/*:refs/heads/*'
git config --add remote.gitlab.push '+refs/heads/*:refs/heads/*'
#Check the initial repository into gitlab
git fetch
git remote prune origin
git push gitlab
