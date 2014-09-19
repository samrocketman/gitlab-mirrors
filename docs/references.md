---
## References

This project is meant to temporarily fill in a gap left by GitLab for managing
remote repository mirrors (namely git and svn).  See the following user voice
topics which enabled me to create this project in the mean time.

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

This project will still be useful after repository mirror support is native in
GitLab because it allows admins to mirror massive amounts of repositories in an
automated fashion.  When native mirror support is included this project will
likely be refactored into a script to automate adding mirrors via the API.

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

