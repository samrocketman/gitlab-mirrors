# Installation and Setup

This assumes you have already satisfied all [prerequisites](prerequisites.md).
You can manage gitlab-mirrors in one of two ways.  You can use your own user
using your own GitLab private token.  Or you can use a dedicated system user and
gitmirror user whose only purpose is to mirror repositories.  The former can be
done by any user where the latter requires administrator privileges in GitLab.

Things to note before beginning:

* GitLab will not allow users (even admins) to add a project to a group unless
  that user is designated an `owner` of the group.  This is by design in GitLab.
* `gitlab-mirrors` will not auto-create a group (though it will auto-create
  projects within a group).  This is by design in `gitlab-mirrors`.  One should
  create the group manually and assign the `gitmirror` user as an owner of the
  group.  This is to ensure mirroring a repository for a particular group is a
  purposeful action.
* `gitlab-mirrors` **must not** be shared by the same user as GitLab which is
  typically the `git` user.  It will not work and you'll run into a lot of
  configuration trouble.

## Using a dedicated GitLab user

### Overview

* Create `gitmirror` system user.
* Create `gitmirror` GitLab Administrator user.
* Create a `Mirrors` group in GitLab owned by `gitmirror` (or name it whatever
  you want).
* Clone gitlab-mirrors repository in `gitmirror` system user.
* Modify `config.sh` using the user token from `gitmirror` GitLab user.
* Create a cron job to update mirrors regularly.

### Create gitmirror system user

Create a system user called `gitmirror` and generate SSH keys.

    adduser gitmirror
    su - gitmirror
    ssh-keygen

Create `~/.ssh/config` for the `gitmirror` user.  Add your GitLab server host
and the user used to talk to GitLab.

    Host gitlab.example.com
        User git

### Create gitmirror GitLab user

Create a `gitmirror` user in GitLab and set the user to be a GitLab
administrator.  Set up the SSH keys with the gitmirror user in GitLab.  Obtain
the Private token from the user.

### Create Mirrors group in GitLab

Create "Mirrors" group in GitLab and designate `gitmirror` GitLab user as the
Owner of the group.  Realistically the group does not have to be called
`Mirrors`.  It could be anything and in fact multiple mirror groups can be
mirrored within the same repository folder.

Clone the gitlab-mirrors repository and set values in config.sh.

    su - gitmirror
    mkdir repositories
    touch private_token
    git clone https://github.com/samrocketman/gitlab-mirrors.git
    cd gitlab-mirrors
    chmod 755 *.sh
    cp config.sh.SAMPLE config.sh

### Modify config.sh

Modify the values in `config.sh` for your setup.
Write the private token of the gitmirror GitLab user into `~/private_token` of
your `gitmirror` system user.

### Schedule cron job

Once you have set up your `config.sh` let's add the `git-mirrors.sh` script to
`crontab`.  Just execute `crontab -e` and add the following value to it.

    @hourly /home/gitmirror/gitlab-mirrors/git-mirrors.sh

### Mirror to multiple GitLab groups

Here's an example of a file tree where I have multiple groups specified with a
different gitlab-mirrors project governing each.

```
/home/gitmirror/
├── mirror-management
│   ├── Mirrors
│   │   ├── authors_files
│   │   └── gitlab-mirrors
│   └── Subscribers
│       └── gitlab-mirrors
└── repositories
    ├── Mirrors
    │   ├── git
    │   ├── gitlabhq
    │   ├── gitlab-shell
    │   ├── nsca-ng
    │   ├── python-gitlab
    │   ├── ruby
    │   └── systems-svn
    └── Subscribers
        └── GitLab Enterprise Edition
```

Where I have all of my gitlab-mirrors installation located in
`/home/gitmirror/mirror-management` and the config.sh for each is similar except
for the `gitlab_namespace` option for each [`config.sh`](../config.sh.SAMPLE).

## Using your own user

Your steps will be similar to using a dedicated `gitmirror` user.  Set up your
SSH keys; copy `config.sh` and configure it; use your own system cron job to
synchronize mirrors on a schedule.  There are a few caveats to using your own
user instead of a dedicated administrator.

1. Currently there is a bug in GitLab 6.0 [#5042][1] which prevents a
   non-Administrator GitLab user from moving a project to a group even if the
   group is owned by the user.  This means that if you wish to mirror projects
   in namespaces other than your own username then you will have to first
   manually create the mirror in GitLab and then run the `add_mirror.sh` command
   (see Managing repositories).  This bug has not been tested in GitLab 7.x/8.x.
2. Your user will include mirror pushes in your user statistics.

---
Next up is [Managing mirrored repositories](management.md)

[1]: https://github.com/gitlabhq/gitlabhq/issues/5042
