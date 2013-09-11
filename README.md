# git-mirrors

The git-mirrors project is designed to fill in a feature which is currently missing from GitLab: the ability to mirror remote repositories.  git-mirrors creates read only copies of remote repositories in gitlab.  It provides a CLI management interface for managing the mirrored repositories (e.g. add, delete, update) so that an admin may regularly update all mirrors using `crontab`.  It operates by interacting with the [GitLab API][1] using [python-gitlab][2].

This adds git mirror functionality to gitlab.  The whole purpose of this project is to mirror projects using the [Mirror group](https://comet.irt.drexel.edu/admin/groups/mirrors).


---
# Prerequisites

### Required software

* [GitLab 6.x][3]
* [python-gitlab @ 5da9bc][2]
* [GNU coreutils][4]
* [git][5]

### Required software install snippets
python-gitlab

    yum install python-setuptools
    git clone https://github.com/Itxaka/python-gitlab.git
    cd python-gitlab
    git checkout 5da9bc7ffcfdca34d86cc69c34caa7a84d27cfaa
    python setup.py

You can find the source to git at the [git-core project](http://code.google.com/p/git-core/).  For instructions on other platforms see the [Getting Started - Installing Git section of the git book](http://git-scm.com/book/en/Getting-Started-Installing-Git).

    yum install perl-ExtUtils-MakeMaker zlib zlib-devel openssh libcurl libcurl-devel expat expat-devel gettext gettext-devel
    cd /usr/local/src/
    git clone https://code.google.com/p/git-core/
    cd git-core/
    git tag
    git checkout v1.8.4
    make configure
    ./configure --prefix=/usr/local
    make
    make install

Your git should now be located in `/usr/local/bin/git`.  You should edit `/etc/profile` and place `/usr/local/bin` at the beginning of your `$PATH`.


---
#Installation and Setup

Create a system user called `gitmirror`.

    adduser gitmirror
    su - gitmirror
    ssh-keygen

Create `~/.ssh/config` for the `gitmirror` user.


---
## References

* [Git Mirror](http://stackoverflow.com/questions/2756747/mirror-a-git-repository-by-pulling)
* [Git Push all Branches](http://stackoverflow.com/questions/1914579/set-up-git-to-pull-and-push-all-branches)
* [Git update Mirror](https://github.com/ndechesne/git-mirror/blob/master/git-mirror)

[1]: https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/README.md
[2]: https://github.com/Itxaka/python-gitlab
[3]: https://github.com/gitlabhq/gitlabhq/tree/6-0-stable
[4]: http://www.gnu.org/software/coreutils/
[5]: http://git-scm.com/
