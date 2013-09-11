#Environment file

repo_dir="/home/gitmirror/repositories"
mirror_list=("gitlabhq")
token_secret="$(head -n1 /home/gitmirror/private_token)"
#This group will contain all code mirrors
gitlab_namespace="Mirrors"
gitlab_url="https://comet.irt.drexel.edu"
gitlab_user="gitmirror"
