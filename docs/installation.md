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
    git clone https://github.com/sag47/git-mirrors.git
    cd gitlab-mirrors
    chmod 755 *.sh
    cp config.sh.SAMPLE config.sh

Modify the values in `config.sh` for your setup.  Be sure to add your private token for the gitmirror user in gitlab to `~/private_token` of your `gitmirror` system user.

Once you have set up your `config.sh` let's add the `git-mirrors.sh` script to `crontab`.  Just execute `crontab -e` and add the following value to it.

    @hourly /home/gitmirror/gitlab-mirrors/git-mirrors.sh

