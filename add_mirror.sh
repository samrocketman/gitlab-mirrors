#!/bin/bash
#Tue Sep 10 23:01:08 EDT 2013
#USAGE
#  ./add_mirror.sh project_name http://example.com/project.git


#Include all user options
. "$(dirname $0)/config.sh"
cd $(dirname $0)

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
