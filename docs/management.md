# Managing mirrored repositories

A short overview of managing mirrored repositories.  This assumes you have already [installed gitlab-mirrors](installation.md).

### Create a mirror

Create a git repository mirror.

    su - gitmirror
    cd gitlab-mirrors
    ./add_mirror.sh --git --project-name someproject --mirror http://example.com/project.git

Create an SVN repository mirror.

    su - gitmirror
    cd gitlab-mirrors
    ./add_mirror.sh --svn --project-name someproject --mirror svn+ssh://user@svn.example.com/srv/repos/someproject --authors-file ./authors.txt

The `--authors-file` option is an optional argument.

### Delete a mirror

    su - gitmirror
    cd gitlab-mirrors
    ./delete_mirror.sh --delete someproject

### Update a mirror

    su - gitmirror
    cd gitlab-mirrors
    ./update_mirror.sh project_name

### Update all known mirrors

    su - gitmirror
    cd gitlab-mirrors
    ./git-mirrors.sh

Updating all known mirrors is also meant to be used with `crontab`.

    @hourly /home/gitmirror/gitlab-mirrors/git-mirrors.sh
