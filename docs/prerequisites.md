# Prerequisites

### Required software

* [GitLab 6.x][1]
* [pyapi-gitlab3 @ v0.5.4][2]
* [GNU coreutils][3]
* [git 1.6.5][4] or later (git 1.6.5 introduced transport helpers)

If you plan on mirroring SVN repositories as well then you'll need the
following additional options.

* [git-svn][7]

If you plan on mirroring BZR repositories then you'll need the following
aditional options.

* [git-bzr-helper][8]

If you plan on mirroring Mercurial repositories then you'll need the following
aditional options.

* [git-hg-helper][9]

### Required software install snippets

#### python-gitlab

    yum install python-setuptools
    git clone https://github.com/alexvh/python-gitlab3.git
    cd python-gitlab3
    git checkout v0.5.4
    python setup.py install


#### Installing git

If you use package management then it will likely be best for you to install git
via package management for your OS.  You can find the source to git at the
[git-core project][5].  For instructions on other platforms see the
[Getting Started - Installing Git section of the git book][6].  The following is
for compiling git 1.8.4 on RHEL 6.4.

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

Your git should now be located in `/usr/local/bin/git`.  You should edit
`/etc/profile` and place `/usr/local/bin` at the beginning of your `$PATH`.

#### git-bzr-helper

    sudo -i -u gitmirror
    mkdir ~/bin
    wget https://raw.github.com/felipec/git/fc/master/git-remote-bzr.py -O ~/bin/git-remote-bzr
    chmod 755 ~/bin/git-remote-bzr

#### git-hg-helper

    sudo -i -u gitmirror
    sudo apt-get install python-rope
    mkdir ~/bin
    wget https://raw.github.com/felipec/git/fc/master/git-remote-hg.py -O ~/bin/git-remote-hg
    chmod 755 ~/bin/git-remote-hg

---
Next up is [Installation and Setup](installation.md).

[1]: https://github.com/gitlabhq/gitlabhq/tree/6-2-stable
[2]: https://github.com/alexvh/python-gitlab3
[3]: http://www.gnu.org/software/coreutils/
[4]: http://git-scm.com/
[5]: http://code.google.com/p/git-core/
[6]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[7]: https://www.kernel.org/pub/software/scm/git/docs/git-svn.html
[8]: https://github.com/felipec/git/wiki/git-remote-bzr
[9]: https://github.com/felipec/git/wiki/git-remote-hg
