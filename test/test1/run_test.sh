#!/bin/bash
# run_test.sh

set -x
scriptName=$(readlink -f $0)
scriptDir=$(dirname ${scriptName})

die() {
    echo "ERROR: $*" >&2
    exit 1
}

main() {
    /bin/env --debug --chdir="$scriptDir" PS1= HOME=$HOME /bin/bash --rcfile $PWD/bashrc
    [[ $? -eq 0 ]] || die "Test failed in $scriptDir"
}

[[ -z ${sourceMe} ]] && main "$@"

