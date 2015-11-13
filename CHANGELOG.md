---
## gitlab-mirrors v0.5.2

* Certified compatibility with GitLab 8.1.4.
* Documentation updates.
* Fixes project transfer bug which is a regression introduced somewhere in
  GitLab 8.x.  This prevented projects being properly created in GitLab under
  the mirror namespace.

---
## gitlab-mirrors v0.5.1

* Certified compatibility with GitLab 7.6.2.
* Documentation updates.
* Add logging to gitlab-mirrors.

---
## gitlab-mirrors v0.5.0

* Support pushing to GitLab via HTTP instead of SSH.
* Force option added for force updating repositories.
* Pruning mirrors is another new feature which will clean up remote repositories
  as the mirror source deletes branches or tags.
* Bugfig project creation defaults in `config.sh` not working.
* More meaningful import error message for gitlab3 python module.
* Minor documentation updates and grammar fixes.

---
## gitlab-mirrors v0.4.9

* Better documentation when viewed from the command line.  No longer stretches
  more than 80 characters.
* Added `no_remote_set` option to `config.sh`.  This forces to only allow
  mirroring to local disk rather than having an addition git remote.
* `--no-remote` option added to `add_mirror.sh`.  This allows a local disk only
  mirror to be added which has no git remote to push.
* Bugfix `private_token` not always required.  In `config.sh` there were minor
  issues with non-GitLab mirroring and no-remote mirroring when GitLab was not
  used at all.  It would falsely fail all scripts.
* Bugfix where svn is sometimes bare causing the update to fail at rare times.

---
## gitlab-mirrors v0.4.8

* Fix bad prerequisite installation docs.

---
## gitlab-mirrors v0.4.7

* Update installation docs to clarify gitlab-mirrors installation process.

---
## gitlab-mirrors v0.4.6

* Fix bug where all scripts break without a meaningful message if config.sh is
  not present.

---
## gitlab-mirrors v0.4.5

* Updated docs for Mercurial mirror management.

---
## gitlab-mirrors v0.4.4

* Added Mercurial mirroring support.  `add_mirror.sh` now has the `--hg` option
  when adding a repository.

---
## gitlab-mirrors v0.4.3

* Added `no_create_set` option to `config.sh`.  This option forces the user to
  always provide a remote for pushing repositories via the `--no-create` option
  in `add_mirror.sh`.

---
## gitlab-mirrors v0.4.2

* Added `--no-create` option to `add_mirror.sh` which gives the script the
  remote to push manually rather than attempting any communication with GitLab.
  This enables gitlab-mirrors to be used with non-gitlab git remotes.  It was
  specifically integrated for the purpose of mirroring gitlab wikis.
* Added `--no-delete` option to `delete_mirror.sh` which only deletes the local
  copy of the mirror and does not attempt communication with GitLab.  This is
  the delete equivalent of `--no-create`.

---
## gitlab-mirrors v0.4.1

* Added upgrade docs for upgrading v0.3 to v0.4

---
## gitlab-mirrors v0.4.0

* Added contributing guidelines
* Added getting help to README.
* Bazaar repository mirroring supported, thanks @agb80.
* Sync tags from remote svn repository, thanks @nikolauskrismer.
* New backend library [python-gitlab3](https://github.com/alexvh/python-gitlab3)
  instead of pyapi-gitlab (formerly python-gitlab).
* Added `ssl_verify` option to [`config.sh`](config.sh.SAMPLE)

---
## gitlab-mirrors v0.3.1

* Updating prerequisite noting minimum git version 1.5.4.  Thanks user
  grawity@freenode from `#git`.  grawity also mentioned git 1.6.5 for
  gitlab-mirrors 0.4.x because that's when transport helpers were introduced.

---
## gitlab-mirrors v0.3.0

* Certified compatibility with GitLab 6.2.
* Upgraded prerequisites to a newer version of `pyapi-gitlab` (formerly
  `python-gitlab`).
* Added upgrade documentation.

---
## gitlab-mirrors v0.2.10

* This is a bugfix release in the gitlab-6-0 branch series.  From now on all
  v0.2.X releases will be for the `gitlab-6-0` branch and all v0.3.X releases
  will be for the `gitlab-6-1` branch.
* Fixed bug where cron job for `update-mirror.sh` would fail if GitLab was
  offline and leave SVN mirrors in an unusable bare state.
* Updating installation docs adding note about `Mirrors` group creation step in
  gitlab, thanks @lmakarov.

---
## gitlab-mirrors v0.2.9

* `git-mirrors.sh` major bugfix where working directory was not properly set
  before executing mirror updates.  This caused the `cron` job to fail.

---
## gitlab-mirrors v0.2.8

* Fixed bug where `manage_gitlab_project.py` would attempt to move a project
  into the user namespace if the `gitlab_namespace` is equal to `gitlab_user`.
  No need to move a project from the same origin/destination group.
* Prerequisite documentation fix for installing `python-gitlab` instructions.
* Added support documentation for running `gitlab-mirrors` from a
  non-administrative user.

---
## gitlab-mirrors v0.2.7

* Renamed `CHANGELOG` to `CHANGELOG.md`

---
## gitlab-mirrors v0.2.6

* *New Feature* command `ls-mirrors.sh`!
* Converted `CHANGELOG` to markdown.
* Fixed bug in preflight check where `merge_requests_enabled` was not being
  checked.
* Fixed bug with bad formatted error output for booleans in preflight check.
* Fixed bug with `lib/manage_gitlab_project.py` where group namespace resolution
  was not properly using API pagination.
  * Required an upstream merge request to the `python-gitlab` library.
* Fixed bug added `merge_requests_enabled` to `config.sh.SAMPLE`.

---
## gitlab-mirrors v0.2.5

* Fixed a critical bug with pagination where API user can't view more projects
  than `20`.
  * Had to merge request upstream `python-gitlab` library for this
    functionality.
* Updated documentation to reference my `bugfix-edition` of `python-gitlab` in
  the prerequisites.

---
## gitlab-mirrors v0.2.4

* Fixing critical `git-svn` mirror bug.  SVN mirroring did not update properly
  prior to this version.

---
## gitlab-mirrors v0.2.3

* Adding a final catch error message to `add_mirror.sh`.
* `RELEASE` file for more consistent releases.

---
## gitlab-mirrors v0.2.2

* Safer environment variable option checking for `config.sh` in `add_mirror.sh`
  command.
* Added Features to `README`

---
## gitlab-mirrors v0.2.1

* CHANGELOG update

---
## gitlab-mirrors v0.2

* Renamed project from `git-mirrors` to `gitlab-mirrors`.
* SVN repository mirroring now supported!
* Project creation defaults can now be set in `config.sh`.
* New `delete_mirror.sh` command.
* Colorized output enabled for all commands.
* Better argument handling on all commands.
* New options for `add_mirror.sh`, see `./add_mirror.sh -h`.
* Knit and grit changes
  * `add_mirror.sh` has more robust error checking.
  * `add_mirror.sh` options can be out of order.  Now using `getopt` for better
    argument handling.
  * `lib/create_gitlab_project.py` has been renamed to
    `lib/manage_gitlab_project.py`.
  * `manage_gitlab_project.py` has a little better error handling.
    * Added `optparse` for better argument handling.

---
## git-mirrors v0.1.1

* Minor update to documentation adding project URL to docs.

---
## git-mirrors v0.1

* Initial project release.  Project gives admins the ability to have mirrors of
  remote git repositories.
* Comes with simple `add_mirror.sh`, `update_mirror.sh`, and `git-mirrors.sh`.
  * Note very little error checking on all commands.
  * `add_mirror.sh` arguments must be in a specific order.
* `add_mirror.sh` utilizes `lib/create_gitlab_project.py` to check for a gitlab
  project.  If it doesn't exist then create it.  When the project exists simply
  return the project remote "git url over ssh".
  * `create_gitlab_project.py` has very little error checking.  Arguments must
    be in a specific order.
* Project is fully documented with documentation.
