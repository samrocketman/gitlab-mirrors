# Managing mirrored repositories

A short overview of managing mirrored repositories.  This assumes you have already [installed git-mirrors](installation.md).

### Create a mirror

    su - gitmirror
    cd git-mirrors
    ./add_mirror.sh project_name http://example.com/repository.git

### Update a mirror

    su - gitmirror
    cd git-mirrors
    ./update_mirror.sh project_name

### Update all known mirrors

    su - gitmirror
    cd git-mirrors
    ./git-mirrors.sh

Updating all known mirrors is also meant to be used with `crontab`.

    @hourly /home/gitmirror/git-mirrors/git-mirrors.sh
