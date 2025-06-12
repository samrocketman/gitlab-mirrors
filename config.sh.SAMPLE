#Environment file

#
# gitlab-mirrors settings
#

DEBUG=${DEBUG:-0}

#The repository directory where gitlab-mirrors will contain copies of mirrored
#repositories before pushing them to gitlab.
repo_dir=${GITLAB_MIRROR_DATADIR:-/data}
#colorize output of add_mirror.sh, update_mirror.sh, and git-mirrors.sh
#commands.
enable_colors=true
#These are additional options which should be passed to git-svn.  On the command
#line type "git help svn"
git_svn_additional_options=${GITLAB_MIRROR_SVN_OPTIONS:-"-s"}
#Force gitlab-mirrors to not create the gitlab remote so a remote URL must be
#provided. (superseded by no_remote_set)
no_create_set=${GITLAB_MIRROR_NO_REMOTES:-false}
#Force gitlab-mirrors to only allow local remotes only.
no_remote_set=${GITLAB_MIRROR_LOCAL_REMOTES:-false}
#Enable force fetching and pushing.  Will overwrite references if upstream
#forced pushed. Applies to git projects only.
force_update=${GITLAB_MIRROR_FORCE_UPDATE:-false}
#This option is for pruning mirrors.  If a branch is deleted upstream then that
#change will propagate into your GitLab mirror.  Aplies to git projects only.
prune_mirrors=${GITLAB_MIRROR_PRUNE_MIRRORS:-false}

#
# Gitlab settings
#

#This is the Gitlab group where all project mirrors will be grouped.
gitlab_namespace=${GITLAB_MIRROR_TOPLEVEL_GROUP:-Mirrors}
#This is the base web url of your Gitlab server.
gitlab_url=${GITLAB_MIRROR_GITLAB_URL:-http://gitlab.com}
#Special user you created in Gitlab whose only purpose is to update mirror sites
#and admin the $gitlab_namespace group.
gitlab_user=${GITLAB_MIRROR_GITLAB_USER:-"gitlab-mirror"}
#Generate a token for your $gitlab_user and set it here.
gitlab_user_token_secret=${GITLAB_MIRROR_GITLAB_TOKEN:-"glpat-myfancytoken"}
#Sets the Gitlab API version, either 3 or 4
gitlab_api_version=4
#Verify signed SSL certificates?
ssl_verify=${GITLAB_MIRROR_IGNORE_SSL:-true}
#Push to GitLab over http?  Otherwise will push projects via SSH.
http_remote=${GITLAB_MIRROR_HTTP_PUSH:-false}

#
# Gitlab new project default settings.  If a project needs to be created by
# gitlab-mirrors then it will assign the following values as defaults.
#

#values must be true or false
issues_enabled=${GITLAB_MIRROR_USE_ISSUES:-false}
wall_enabled=${GITLAB_MIRROR_USE_WALL:-false}
wiki_enabled=${GITLAB_MIRROR_USE_WIKI:-false}
snippets_enabled=${GITLAB_MIRROR_USE_SNIPPETS:-false}
merge_requests_enabled=${GITLAB_MIRROR_USE_MERGEREQUESTS:-false}
visibility=${GITLAB_MIRROR_VISIBILITY:-private}
