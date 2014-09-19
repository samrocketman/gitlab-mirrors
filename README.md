# gitlab-mirrors

The [gitlab-mirrors](https://github.com/samrocketman/gitlab-mirrors) project is
designed to fill in a feature which is currently
[missing from GitLab][mirror-missing]: the ability to mirror remote
repositories.  gitlab-mirrors creates read only copies of remote repositories in
gitlab.  It provides a CLI management interface for managing the mirrored
repositories (e.g. add, delete, update) so that an admin may regularly update
all mirrors using `crontab`.  It operates by interacting with the
[GitLab API][gitlab-api] using [python-gitlab3][python-gitlab3].


## Features

* Mirror different types of source repositories:  Bazaar, Git, Mercurial,
  Subversion.  Mirror all into git.
* GitLab mirror adding.
  * When adding a mirror if the project doesn't exist in GitLab it will be
    auto-created.
  * Set project creation defaults (e.g. issues enabled, wiki enabled, etc.)
  * Delete mirrors both local and remote.
* non-GitLab mirror adding.
  * Manually specify the remote and don't attempt API communication to GitLab
    nor attempt to create the remote project.
  * Delete mirrors locally only without communicating to GitLab to delete the
    remote project.
  * This feature is for mirroring git repositories generically which can be used
    by any git hosting server or service.  This feature was originally added
    with mirroring GitLab wikis in mind but allows gitlab-mirrors to be more
    versatile.
  * no-remote mirroring where you don't need a remote git repository at all.
    Just mirror the repositories to local disk.
* Update a single mirror.
* Update all known mirrors.
* List all known mirrors.


---
# Three easy steps

1. [Setup prerequisites](docs/prerequisites.md)
2. [Install gitlab-mirrors](docs/installation.md)
3. [Manage your mirrors](docs/management.md)

*Note: if you are upgrading then see `docs/upgrade` for notes on upgrading.*


---
# Get help

There are a couple ways you can try to get help.  You can
[file an issue][issues].  You can also join the `#gitlab` IRC channel at
freenode.net and direct your questions to user `sag47`.

## IRC Etiquette

* I generally stay logged in to freenode so be sure to mention my handle when
  you're asking questions so that I see it in the `#gitlab` channel.
* If I don't answer right away then just hang out in the channel.  I will
  eventually write back to you as it just means I'm away from my keyboard,
  working on something else, or in a different timezone than you.
* You should treat IRC as what it is: asynchronous chat.  Sure the messages can
  be instant but in most channels people are in different time zones.  At times
  chat replies can be in excess of 24hrs.


---
# Contributing

I enjoy contributions and encourage them!  You should add your code to my
project and make your mark.  [Pick off an issue][issues] or implement a feature
filling your need.  I only make a few simple requests in order to contribute.

* Test your own work before submitting a pull request.  Most of this project is
  bash code so we do not have the luxury of a test driven framework to assist
  our development.  Needless to say I will be sure to test it myself before it
  ever makes it into a production release.
* Create a feature branch with a name that does not exist in any of my branches
  (e.g. `feature/myfeature` or `feature-cool_feature`).  This is where you
  should do your development.  This will allow you to integrate my development
  with your own and ease integrating updated code if we're both concurrently
  developing.
* When your feature is ready make a pull request to the *development* branch.
  Pull requests to the master branch will not be accepted.  The master branch is
  intended to drive production systems and only stable production-ready commits
  will be made to it.

Happy hacking!

---
# License

Created by Sam Gleske under [MIT License](LICENSE).

## Contributors

* Docs #1 [lmakarov](https://github.com/lmakarov)
* Bzr support #6 [Agustín Cruz Lozano](https://github.com/agb80) (atin81@gmail.com)
* SVN update tags #13 [Nikolaus Krismer](https://github.com/nikolauskrismer)
* Docs #26 [Glen Mailer](https://github.com/glenjamin)

[mirror-missing]: http://feedback.gitlab.com/forums/176466-general/suggestions/4286666-mirror-git-svn-into-repo-
[gitlab-api]: http://api.gitlab.org/
[python-gitlab3]: https://github.com/alexvh/python-gitlab3
[issues]: https://github.com/samrocketman/gitlab-mirrors/issues
