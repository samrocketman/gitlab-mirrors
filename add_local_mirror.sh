#!/bin/bash
#Created by L
#MIT License
#Created Sat Apr 9 18:43:46 EDT 207
#USAGE
#  ./add_local_mirror.sh --git --project-name someproject --mirror /path/to/local/repository/

#bash option stop on first error
set -e

echo "${0%/*}"

# only git repos supported for now
if [ $1 = '--git' ]; then
   	# creating a mirror with the provided script in 'gitlab-mirrors' (passing the same parameters)
	bash ./add_mirror.sh "$@"

	# tweaking some configurations for the repository
	(cd "${repo_dir}/${gitlab_namespace}"/"${project_name}" && git config --get remote.origin.url) | (cd "${repo_dir}/${gitlab_namespace}"/"${project_name}" && git remote set-url origin $args)
else
   	echo "Only Git repos are supported for local mirroring."
fi
