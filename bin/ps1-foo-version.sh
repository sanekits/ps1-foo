#!/bin/bash

# Running cdpp-version.sh is the correct way to
# get the home path for cdpp and its tools.
Ps1FooVersion=0.5.0

set -e

Script=$(readlink -f "$0")
Scriptdir=$(dirname -- "$Script")


if [ -z "$sourceMe" ]; then
    printf "%s\t%s" ${Scriptdir}/ps1-foo ${Ps1FooVersion}
fi
