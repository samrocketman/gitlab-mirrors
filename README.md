# gitlab-mirrors

The [gitlab-mirrors](https://github.com/sag47/gitlab-mirrors) project is designed to fill in a feature which is currently missing from GitLab: the ability to mirror remote repositories.  gitlab-mirrors creates read only copies of remote repositories in gitlab.  It provides a CLI management interface for managing the mirrored repositories (e.g. add, delete, update) so that an admin may regularly update all mirrors using `crontab`.  It operates by interacting with the [GitLab API][1] using [python-gitlab][2].


## Features

* Mirror git and SVN repositories.
* When adding a mirror if the project doesn't exist in GitLab then `add_mirrror.sh` will automatically create it.
  * Specify initial project defaults when a project is created (e.g. issues enabled, wiki enabled, etc.)
* Update a single mirror with the `update_mirror.sh` command.
* Update all known mirrors with the `git-mirrors.sh` command.  Useful for adding to a `cron` job for updating all repositories on a regular schedule.


---
# Three easy steps

1. [Setup prerequisites](docs/prerequisites.md)
2. [Install gitlab-mirrors](docs/installation.md)
3. [Manage your mirrors](docs/management.md)


---
# License

Created by Sam Gleske under [MIT License](LICENSE).  This project is meant to temporarily fill in a gap left by GitLab for managing remote git mirrors.  See the following user voice topics which made me create this project in the mean time.

* [Mirror git/svn into repo.][3]
* [Feature request -- Multi-Master mirroring][4]


---
## References

* [Git mirror][5]
* [Git push all branches][6]
* [Git update mirror][7]
* [Splitting Subversion into Multiple Git Repositories][8]
* [Git-svn Tutorial][9]
* [Why git can't clone into a bare repository][10]
* [How to convert a git repository from normal to bare][11]

[1]: https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/README.md
[2]: https://github.com/Itxaka/python-gitlab
[3]: http://feedback.gitlab.com/forums/176466-general/suggestions/4286666-mirror-git-svn-into-repo-
[4]: http://feedback.gitlab.com/forums/176466-general/suggestions/3697598-feature-request-multi-master-mirroring
[5]: http://stackoverflow.com/questions/2756747/mirror-a-git-repository-by-pulling
[6]: http://stackoverflow.com/questions/1914579/set-up-git-to-pull-and-push-all-branches
[7]: https://github.com/ndechesne/git-mirror/blob/master/git-mirror
[8]: http://daneomatic.com/2010/11/01/svn-to-multiple-git-repos/
[9]: http://trac.parrot.org/parrot/wiki/git-svn-tutorial
[10]: http://stackoverflow.com/questions/12544318/why-git-svn-cannot-clone-a-bare-repo
[11]: http://stackoverflow.com/questions/2199897/how-to-convert-a-git-repository-from-normal-to-bare
