# Prerequisites

### Required software

* [Tested with GitLab 6.x/7.x/8.x][gitlab]
* [pyapi-gitlab3 @ v0.5.4][python-gitlab3]
* [GNU coreutils][coreutils]
* [git 1.8.0][git] or later

If you plan on mirroring SVN repositories as well then you'll need the
following additional options.

* [git-svn][git-svn]

If you plan on mirroring BZR repositories then you'll need the following
aditional options.

* [git-bzr-helper][git-bzr]

If you plan on mirroring Mercurial repositories then you'll need the following
aditional options.

* [git-hg-helper][git-hg]

### Required software install snippets

#### python-gitlab3

    yum install python-setuptools
    git clone https://github.com/alexvh/python-gitlab3.git
    cd python-gitlab3
    git checkout v0.5.4
    python setup.py install


#### Installing git

If you use package management then it will likely be best for you to install git
via package management for your OS.  You can find the source to git at the
[git-core project][git-src].  For instructions on other platforms see the
[Getting Started - Installing Git section of the git book][git-guide].  The following is
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

#### git-svn

Notice in [`config.sh.SAMPLE`](../config.sh.SAMPLE) the option
`git_svn_additional_options="-s"`.  This behavior assumes that your SVN project
is laid out with a standard directory structure: `trunk/`, `branches/`, and
`tags/`.  If your project does not conform to this layout then you should modify
that option by removing `-s`.  That means setting
`git_svn_additional_options=""`.   See the [`git-svn(1)`][git-svn] man page to
learn more about what `-s` does.  The additional options will pass in parameters
to the `git svn` command.  If a project to be mirrored has a custom layout then
this option can be modified to account for that.

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

[coreutils]: http://www.gnu.org/software/coreutils/
[git-bzr]: https://github.com/felipec/git/wiki/git-remote-bzr
[git-guide]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[git-hg]: https://github.com/felipec/git/wiki/git-remote-hg
[git]: http://git-scm.com/
[gitlab]: https://about.gitlab.com/
[git-src]: http://code.google.com/p/git-core/
[git-svn]: https://www.kernel.org/pub/software/scm/git/docs/git-svn.html
[python-gitlab3]: https://github.com/alexvh/python-gitlab3
