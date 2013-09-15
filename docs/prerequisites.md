# Prerequisites

### Required software

* [GitLab 6.x][1]
* [python-gitlab @ 9c5e375][2]
* [GNU coreutils][3]
* [git 1.8.4][4]

If you plan on mirroring SVN repositories as well then you'll need the following additional options.

* [git-svn][7]

### Required software install snippets
python-gitlab

    yum install python-setuptools
    git clone https://github.com/Itxaka/python-gitlab.git
    cd python-gitlab
    git checkout 9c5e375599a6d89ab1f4520224f47b43b40bcf9b
    python setup.py

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

---
Next up is [Installation and Setup](installation.md).

[1]: https://github.com/gitlabhq/gitlabhq/tree/6-0-stable
[2]: https://github.com/Itxaka/python-gitlab
[3]: http://www.gnu.org/software/coreutils/
[4]: http://git-scm.com/
[5]: http://code.google.com/p/git-core/
[6]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[7]: https://www.kernel.org/pub/software/scm/git/docs/git-svn.html
