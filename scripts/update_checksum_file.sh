#!/bin/bash
cd ..
find . -type f -a \( -name "VERSION" -o -name "*.py" -o -name "*.sh" \) -exec md5sum {} \;
