# Prerequisites

### Required software

* [GitLab 6.x][1]
* [pyapi-gitlab @ 4d778d7][2]
* [GNU coreutils][3]
* [git 1.8.4][4]

If you plan on mirroring SVN repositories as well then you'll need the following additional options.

* [git-svn][7]

If you plan on mirroring BZR repositories then you'll need the following aditional options.

* [git-bzr-helper][8]

### Required software install snippets
python-gitlab

    yum install python-setuptools
    git clone https://github.com/Itxaka/python-gitlab.git
    cd python-gitlab
    git checkout 4d778d780161869550d8e514cdc50df2398f844e
    python setup.py install

You can find the source to git at the [git-core project][5].  For instructions on other platforms see the [Getting Started - Installing Git section of the git book][6].

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

git-bzr-helper

    sudo -i -u gitmirror
    sudo apt-get install python-rope
    mkdir ~/bin
    wget https://raw.github.com/felipec/git/fc/master/git-remote-hg.py -O ~/bin/git-remote-bzr
    chmod 755 ~bin/git-remote-bzr

---
Next up is [Installation and Setup](installation.md).

[1]: https://github.com/gitlabhq/gitlabhq/tree/6-2-stable
[2]: https://github.com/Itxaka/pyapi-gitlab
[3]: http://www.gnu.org/software/coreutils/
[4]: http://git-scm.com/
[5]: http://code.google.com/p/git-core/
[6]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[7]: https://www.kernel.org/pub/software/scm/git/docs/git-svn.html
[8]: https://github.com/felipec/git/wiki/git-remote-bzr
