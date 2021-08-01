#!/bin/bash

set -eu

SSH_DIR=/home/gitmirror/.ssh

if [ ! -f "$SSH_DIR/id_ed25519" ]; then
	echo -e " * No SSH key found in $SSH_DIR.\n\
 * You can generate a key like this:
	 ssh-keygen -t ed25519 -f /path/to/ssh/key/dir/id_ed25519 -qN \"\"
 * Then make sure to run this image with --volume /path/to/ssh/key/dir:$SSH_DIR"
fi

exec "$@"
