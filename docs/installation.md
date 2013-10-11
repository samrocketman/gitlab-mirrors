# Installation and Setup

This assumes you have already satisfied all [prerequisites](prerequisites.md).  You can manage gitlab-mirrors in one of two ways.  You can use your own user using your own GitLab private token.  Or you can use a dedicated system user and gitmirror user whose only purpose is to mirror repositories.  The former can be done by any user where the latter requires administrator privileges in GitLab.

## Using a dedicated GitLab user

Create a system user called `gitmirror` and generate SSH keys.

    adduser gitmirror
    su - gitmirror
    ssh-keygen

Create `~/.ssh/config` for the `gitmirror` user.  Add your GitLab server host and the user used to talk to GitLab.

    Host gitlab.example.com
        User git

Create a gitmirror user in gitlab.  Set up the SSH keys with the gitmirror user in GitLab.  Obtain the Private token from the user.

Create "Mirrors" group in gitlab and designate gitmirror user as the Owner of the group.

Clone the gitlab-mirrors repository and set values in config.sh.

    su - gitmirrors
    mkdir repositories
    touch private_token
    git clone https://github.com/sag47/gitlab-mirrors.git
    cd gitlab-mirrors
    chmod 755 *.sh
    cp config.sh.SAMPLE config.sh

Modify the values in `config.sh` for your setup.  Be sure to add your private token for the gitmirror user in gitlab to `~/private_token` of your `gitmirror` system user.

Once you have set up your `config.sh` let's add the `git-mirrors.sh` script to `crontab`.  Just execute `crontab -e` and add the following value to it.

    @hourly /home/gitmirror/gitlab-mirrors/git-mirrors.sh

## Using your own user

Your steps will be similar to using a dedicated `gitmirror` user.  Set up your SSH keys; copy `config.sh` and configure it; use your own system cron job to synchronize mirrors on a schedule.  There are a few caveats to using your own user instead of a dedicated administrator.

1. Currently there is a bug in GitLab 6.0 [#5042][1] which prevents a non-Administrator GitLab user from moving a project to a group even if the group is owned by the user.  This means that if you wish to mirror projects in namespaces other than your own username then you will have to first manually create the mirror in GitLab and then run the `add_mirror.sh` command (see Managing repositories).
2. You user will include mirror pushes in your user statistics.

---
Next up is [Managing mirrored repositories](management.md)

[1]: https://github.com/gitlabhq/gitlabhq/issues/5042
