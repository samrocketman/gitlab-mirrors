#!/bin/bash

set -euo pipefail

set -x

pushd ..
# echo "Testing flat mirror hierarchy creation"
# ./add-mirror.sh --project-name test --mirror https://github.com/DevelopersHeaven/LogWitch.git --git

# echo "Testing flat mirror hierarchy deletion"
# echo y | ./delete-mirror.sh --delete test



echo "Testing mirror hierarchy creation depth = 1"
./add-mirror.sh --project-name test/123123/3333333/123 --mirror https://github.com/DevelopersHeaven/LogWitch.git --git


echo y | ./delete-mirror.sh --delete test/123



popd