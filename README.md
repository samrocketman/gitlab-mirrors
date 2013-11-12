# gitlab-mirrors

The [gitlab-mirrors](https://github.com/sag47/gitlab-mirrors) project is designed to fill in a feature which is currently missing from GitLab: the ability to mirror remote repositories.  gitlab-mirrors creates read only copies of remote repositories in gitlab.  It provides a CLI management interface for managing the mirrored repositories (e.g. add, delete, update) so that an admin may regularly update all mirrors using `crontab`.  It operates by interacting with the [GitLab API][1] using [python-gitlab][2].


## Features

* Mirror different types of repositories:  Bazaar, git, subversion.
* When adding a mirror if the project doesn't exist in GitLab it will be auto-created.
  * Set project creation defaults (e.g. issues enabled, wiki enabled, etc.)
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

There are a couple ways you can try to get help.  You can [file an issue](https://github.com/sag47/gitlab-mirrors/issues).  You can also join the `#gitlab` IRC channel at freenode.net and direct your questions to user `sag47`.  

## IRC Etiquette

* I generally stay logged in to freenode so be sure to mention my handle when you're asking questions so that I see it in the `#gitlab` channel.
* If I don't answer right away then just hang out in the channel or do other stuff with your life.  I will eventually write back to you as it just means I'm away from my keyboard, working on something else, or in a different timezone than you.
* You should treat IRC as what it is: asynchronous chat.  Sure the messages can be instant but in most channels people are in different time zones so coming in and demanding help and then leaving immediately will not get your problem solved.


---
# Contributing

I enjoy contributions and encourage them!  You should add your code to my project and make your mark.  [Pick off an issue](https://github.com/sag47/gitlab-mirrors/issues) or implement a feature filling your need.  I only make a few simple requests in order to contribute.

* Test your own work before submitting a pull request.  Most of this project is bash code so we do not have the luxury of a test driven framework to assist our development.  Needless to say I will be sure to test it myself before it ever makes it into a production release.
* Create a feature branch with a name that does not exist in any of my branches (e.g. `feature/myfeature` or `feature-cool_feature`).  This is where you should do your development.  This will allow you to integrate my development with your own and ease integrating updated code if we're both concurrently developing.
* When your feature is ready make a pull request to the *development* branch.  Pull requests to the master branch will not be accepted.  The master branch is intended to drive production systems and only stable production-ready commits will be made to it.

Happy hacking!

---
# License

Created by Sam Gleske under [MIT License](LICENSE).  

## Contributors

* Docs #1 [lmakarov](https://github.com/lmakarov)
* Bzr support #6 [Agustín Cruz Lozano](https://github.com/agb80) (atin81@gmail.com)
* SVN update tags #13 [Nikolaus Krismer](https://github.com/nikolauskrismer)


---
## References

This project is meant to temporarily fill in a gap left by GitLab for managing remote repository mirrors (namely git and svn).  See the following user voice topics which enabled me to create this project in the mean time.

* [Mirror git/svn into repo.][3]
* [Feature request -- Multi-Master mirroring][4]
* [Git mirror][5]
* [Git push all branches][6]
* [Git update mirror][7]
* [Splitting Subversion into Multiple Git Repositories][8]
* [Git-svn Tutorial][9]
* [Why git can't clone into a bare repository][10]
* [How to convert a git repository from normal to bare][11]
* [Converting CVS repositories to git][12]

This project will still be useful after repository mirror support is native in GitLab because it allows admins to mirror massive amounts of repositories in an automated fashion.  When native mirror support is included this project will likely be refactored into a script to automate adding mirrors via the API.

[1]: https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/README.md
[2]: https://github.com/sag47/python-gitlab
[3]: http://feedback.gitlab.com/forums/176466-general/suggestions/4286666-mirror-git-svn-into-repo-
[4]: http://feedback.gitlab.com/forums/176466-general/suggestions/3697598-feature-request-multi-master-mirroring
[5]: http://stackoverflow.com/questions/2756747/mirror-a-git-repository-by-pulling
[6]: http://stackoverflow.com/questions/1914579/set-up-git-to-pull-and-push-all-branches
[7]: https://github.com/ndechesne/git-mirror/blob/master/git-mirror
[8]: http://daneomatic.com/2010/11/01/svn-to-multiple-git-repos/
[9]: http://trac.parrot.org/parrot/wiki/git-svn-tutorial
[10]: http://stackoverflow.com/questions/12544318/why-git-svn-cannot-clone-a-bare-repo
[11]: http://stackoverflow.com/questions/2199897/how-to-convert-a-git-repository-from-normal-to-bare
[12]: http://stackoverflow.com/questions/7344941/converting-cvs-repositories-to-git
