# Upgrade Notes

This documentation outlines steps for you to upgrade from gitlab-mirrors `0.2.x`
to gitlab-mirrors `0.3.x`.  It is assumed you'll be working on a test instance
of gitlab in a production environment.  If you only have a single gitlab
instance then follow these steps with care and at your own risk.

gitlab-mirrors has been certified to use a new prerequisite library called
[pyapi-gitlab](https://github.com/Itxaka/pyapi-gitlab) (formerly called
python-gitlab).  Therefore you must install `pyapi-gitlab` before upgrading
`gitlab-mirrors` to the latest edition.

# 1. Disable any cron jobs

If you have cron jobs set up then you'll need to disable them to avoid them
launching gitlab-mirrors during your upgrade.

# 2. Update pyapi-gitlab to python-gitlab3

I'll ouline the steps here real quick.

    cd /usr/local/src
    rm -rf pyapi-gitlab
    git clone https://github.com/alexvh/python-gitlab3.git
    cd python-gitlab3
    v0.5.2
    python setup.py install

You must remove the previous conflicting library from
`/usr/local/lib/python2.7/dist-packages/pyapi_gitlab-0.1-py2.7.egg` by default
on my system.  Your system may vary the location.  If you're not sure where it's
at then you can locate it using `mlocate` package in RHEL.

    yum install mlocate
    updatedb
    locate pyapi_gitlab
    rm -rf /usr/local/lib/python2.7/dist-packages/pyapi_gitlab-0.1-py2.7.egg

# 3. Update your gitlab-mirrors

    su - gitmirror
    cd gitlab-mirrors
    git checkout master
    git fetch
    git pull origin master
    git checkout v0.4.1

Test on a dummy project to ensure your new setup works.  Once you have verified
everything works then you can re-enable the cron jobs.
