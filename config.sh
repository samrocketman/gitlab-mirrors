#Environment file

#
# gitlab-mirror settings
#
repo_dir="/home/gitmirror/repositories"

#
# Gitlab settings
#

#This is the Gitlab group where all project mirrors will be grouped.
gitlab_namespace="Mirrors"
#This is the web url of your Gitlab server. no trailing slash, just the protocol and server name.
gitlab_url="https://comet.irt.drexel.edu"
#Special user you created in Gitlab whose only purpose is to update mirror sites and admin the $gitlab_namespace group.
gitlab_user="gitmirror"
#Generate a token for your $gitlab_user and set it here.
gitlab_user_token_secret="$(head -n1 /home/gitmirror/private_token)"
