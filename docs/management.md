# Managing mirrored repositories

A short overview of managing mirrored repositories.  This assumes you have already [installed gitlab-mirrors](installation.md).

*Note: any repository type other than git may or may not update the CLI with status text.  For extremely large alternate repository types (e.g. Bazaar) it can take a long time to clone with little or no output to the CLI until the initial BZR clone has finished.*

### Create a mirror

Create a git repository mirror.

    su - gitmirror
    cd gitlab-mirrors
    ./add_mirror.sh --git --project-name github-gitlab-mirrors --mirror https://github.com/sag47/gitlab-mirrors.git

Create an SVN repository mirror.

    su - gitmirror
    cd gitlab-mirrors
    ./add_mirror.sh --svn --project-name someproject --mirror svn+ssh://user@svn.example.com/srv/repos/someproject --authors-file ./authors.txt

The `--authors-file` option is an optional argument.  See `add_mirror.sh -h` for details.

Create a BZR repository mirror.

    su - gitmirror
    cd gitlab-mirrors
    ./add_mirror.sh --bzr --project-name bzr-ubuntu-hello --mirror lp:ubuntu/hello

### List all known mirrors

    su - gitmirror
    cd gitlab-mirrors
    ./ls-mirrors.sh

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
