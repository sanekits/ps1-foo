#!/bin/bash
# run_tests.sh

scriptName=$(readlink -f $0)
scriptDir=$(dirname -- ${scriptName})

die() {
    echo "ERROR: $*" >&2
    exit 1
}

main() {
    cd ${scriptDir}/test || die 101
    for test_script in */run_test.sh; do
        (
            cd $(dirname ${test_script}) || die 102
            echo "Running tests in $PWD:"
            ./run_test.sh
        )
    done
}

[[ -z ${sourceMe} ]] && main "$@"
