# Managing mirrored repositories

A short overview of managing mirrored repositories.  This assumes you have
already [installed gitlab-mirrors](installation.md).

Currently gitlab-mirrors supports the following repository types.

* Bazaar
* git
* svn

*Note: any repository type other than git may or may not update the CLI with
status text.  For extremely large alternate repository types (e.g. Bazaar) it
can take a long time to clone with little or no output to the CLI until the
initial BZR clone has finished.*

## Create a mirror

See also `./add_mirror.sh --help`.

### Bazaar

The Bazaar support comes from
[`git-remote-bzr`](https://github.com/felipec/git/wiki/git-remote-bzr).

Create a BZR repository mirror.

    su - gitmirror
    cd gitlab-mirrors
    ./add_mirror.sh --bzr --project-name bzr-ubuntu-hello --mirror lp:ubuntu/hello

### Git

Create a git repository mirror.

    su - gitmirror
    cd gitlab-mirrors
    ./add_mirror.sh --git --project-name github-gitlab-mirrors --mirror https://github.com/samrocketman/gitlab-mirrors.git

Create a git repository mirror without attempting to auto-create the project and
just take a remote.

    ./add_mirror.sh --git --project-name github-gitlab-mirrors --mirror https://github.com/samrocketman/gitlab-mirrors.git --no-create user@yourserver.com:projects/gitlab-mirrors.git

### Mercurial

The Mercurial support comes from
[`git-remote-hg`](https://github.com/felipec/git/wiki/git-remote-hg).

Create a hg repository mirror.

    su - gitmirror
    cd gitlab-mirrors
    ./add_mirror.sh --hg --project-name lodgeit-main --mirror https://bitbucket.org/EnTeQuAk/lodgeit-main

### Subversion

The subversion support comes from [`git-svn(1)`][git-svn-man].

Create an SVN repository mirror.

    su - gitmirror
    cd gitlab-mirrors
    ./add_mirror.sh --svn --project-name someproject --mirror svn+ssh://user@svn.example.com/srv/repos/someproject --authors-file ./authors.txt

The `--authors-file` option is an optional argument.  It serves the same purpose
as the `git-svn --authors-file` option.  It is an authors file for mapping SVN
users to git users.  See the [`git-svn(1)`][git-svn-man] man page for more
details.

Notice in [`config.sh`](../config.sh.SAMPLE) there's an option
`git_svn_additional_options`.  This option affects `add_mirror.sh` and the
creation of a mirror only.  It doesn't affect the synchronization of the svn
repository.  See the [`git-svn(1)`][git-svn-man] man page under `init` COMMAND
options for available values which can be set.

### No Remote repository mirroring

    su - gitmirror
    cd gitlab-mirrors
    ./add_mirror --git --project-name someproject --mirror git@server:repo.git --no-remote

By using the `--no-remote` option repositories on the internet can be mirrored
locally on disk.  It does not attempt to reach out to gitlab at all.

## List all known mirrors

See also `./ls-mirrors.sh --help`.

    su - gitmirror
    cd gitlab-mirrors
    ./ls-mirrors.sh

## Delete a mirror

See also `./delete_mirror.sh --help`.

    su - gitmirror
    cd gitlab-mirrors
    ./delete_mirror.sh --delete someproject

## Update a mirror

    su - gitmirror
    cd gitlab-mirrors
    ./update_mirror.sh project_name

## Update all known mirrors

    su - gitmirror
    cd gitlab-mirrors
    ./git-mirrors.sh

Updating all known mirrors is also meant to be used with a cron job via
`crontab`.  See `man 5 crontab`.

    @hourly /home/gitmirror/gitlab-mirrors/git-mirrors.sh

[git-svn-man]: https://www.kernel.org/pub/software/scm/git/docs/git-svn.html
