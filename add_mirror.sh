#!/bin/bash

#Include all user options
. "$(dirname $0)/config.sh"
cd $(dirname $0)

export token_secret gitlab_url gitlab_namespace
python lib/create_gitlab_project.py test2
