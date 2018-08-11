# Upgrade Notes

This documentation outlines steps for you to upgrade from gitlab-mirrors `0.5.x`
to gitlab-mirrors `0.6.x`.  It is assumed you'll be working on a test instance
of gitlab in a production environment.  If you only have a single gitlab
instance then follow these steps with care and at your own risk.

gitlab-mirrors has been certified to use a new prerequisite library called
[python-gitlab](https://github.com/python-gitlab/python-gitlab).  Therefore you
must install `python-gitlab` before upgrading `gitlab-mirrors` to the latest
edition.

# 1. Disable any cron jobs

If you have cron jobs set up then you'll need to disable them to avoid them
launching gitlab-mirrors during your upgrade.

# 2. Update python-gitlab3 python-gitlab

I'll ouline the steps here real quick.

    yum install python-pip
    pip uninstall gitlab3
    pip install python-gitlab

# 3. Update your gitlab-mirrors

    su - gitmirror
    cd gitlab-mirrors
    git checkout master
    git fetch
    git pull origin master
    git checkout v0.6.x

Test on a dummy project to ensure your new setup works.  Once you have verified
everything works then you can re-enable the cron jobs.

# Alternatively

Rely on virtualenv.

    virtualenv -p python2.7 .venv
    source ./.venv/bin/activate
    pip install python-gitlab

Be sure to source ./.venv/bin/activate before running gitlab-mirrors shell
scripts.
