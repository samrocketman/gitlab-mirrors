# git-mirrors

The git-mirrors project is designed to fill in a feature which is currently missing from GitLab: the ability to mirror remote repositories.  git-mirrors creates read only copies of remote repositories in gitlab.  It provides a CLI management interface for managing the mirrored repositories (e.g. add, delete, update) so that an admin may regularly update all mirrors using `crontab`.  It operates by interacting with the [GitLab API][1] using [python-gitlab][2].

This adds git mirror functionality to gitlab.  The whole purpose of this project is to mirror projects using the [Mirror group](https://comet.irt.drexel.edu/admin/groups/mirrors).


---
# Prerequisites

### Required software

* [GitLab 6.x][3]
* [python-gitlab @ 5da9bc7][2]
* [GNU coreutils][4]
* [git 1.8.4][5]

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
# Installation and Setup

Create a system user called `gitmirror` and generate SSH keys.

    adduser gitmirror
    su - gitmirror
    ssh-keygen

Create `~/.ssh/config` for the `gitmirror` user.  Add your GitLab server host and the user used to talk to GitLab.

    Host gitlab.example.com
        User git

Create a gitmirror user in gitlab.  Set up the SSH keys with the gitmirror user in GitLab.  Obtain the Private token from the user.

Clone the git-mirrors repository and set values in config.sh.

    su - gitmirrors
    mkdir repositories
    touch private_token
    git clone https://comet.irt.drexel.edu/gitlab/gitlab-mirrors.git
    cd gitlab-mirrors
    chmod 755 *.sh
    cp config.sh.SAMPLE config.sh

Modify the values in `config.sh` for your setup.  Be sure to add your private token for the gitmirror user in gitlab to `~/private_token` of your `gitmirror` system user.

Once you have set up your `config.sh` let's add the `git-mirrors.sh` script to `crontab`.  Just execute `crontab -e` and add the following value to it.

    @hourly /home/gitmirror/gitlab-mirrors/git-mirrors.sh

---
## References

* [Git mirror](http://stackoverflow.com/questions/2756747/mirror-a-git-repository-by-pulling)
* [Git push all branches](http://stackoverflow.com/questions/1914579/set-up-git-to-pull-and-push-all-branches)
* [Git update mirror](https://github.com/ndechesne/git-mirror/blob/master/git-mirror)

[1]: https://github.com/gitlabhq/gitlabhq/blob/master/doc/api/README.md
[2]: https://github.com/Itxaka/python-gitlab
[3]: https://github.com/gitlabhq/gitlabhq/tree/6-0-stable
[4]: http://www.gnu.org/software/coreutils/
[5]: http://git-scm.com/
