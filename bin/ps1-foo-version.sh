#!/bin/bash

# Running ps1-foo-version.sh is the correct way to
# get the home path for ps1-foo and its tools.
Ps1FooVersion=0.7.5

set -e

Script=$(readlink -f "$0")
scriptDir=$(dirname -- "$Script")


if [ -z "$sourceMe" ]; then
    printf "%s\t%s" ${scriptDir}/ps1-foo ${Ps1FooVersion}
fi
