### 
# After building (eg. `docker build -t gitlab-mirrors .`) ...
# you are expected to formulate a `docker run` command like the following:
#
# docker run -ti \
#    --volume /path/to/config.sh:/home/gitmirror/gitlab-mirrors/config.sh:ro \
#    --volume /path/to/ssh-keys:/home/gitmirror/.ssh \
#    --volume /path/to/repositories:/home/gitmirror/repositories \
#    gitlab-mirrors \
#    <gitlab-mirrors cmd> <cmd options> # eg. add_mirror.sh --help 
###
FROM debian:10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -yqq \
            python-pip \
            git

RUN pip install python-gitlab

RUN adduser --shell /bin/sh --disabled-password --gecos "" gitmirror

RUN mkdir /home/gitmirror/gitlab-mirrors

COPY . /home/gitmirror/gitlab-mirrors

RUN chown -R gitmirror:gitmirror /home/gitmirror

USER gitmirror

WORKDIR /home/gitmirror/gitlab-mirrors

RUN mkdir /home/gitmirror/repositories && \
    chmod 755 /home/gitmirror/gitlab-mirrors/*.sh

ENV PATH=$PATH:/home/gitmirror/gitlab-mirrors

ENTRYPOINT [ "/bin/bash", "/home/gitmirror/gitlab-mirrors/scripts/docker/entrypoint.sh" ]
