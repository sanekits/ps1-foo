#!/bin/bash
# setup.sh

canonpath() {
    ( cd -L -- "$(dirname -- $0)"; echo "$(pwd -P)/$(basename -- $0)" )
}

stub() {
   builtin echo "  <<< STUB[$*] >>> " >&2
}
scriptName="$(canonpath  $0)"
scriptDir=$(command dirname -- "${scriptName}")

stub "scriptDir=${scriptDir}"
source ${scriptDir}/shellkit/setup-base.sh

die() {
    builtin echo "ERROR: $*" >&2
    builtin exit 1
}

main() {
    builtin echo "args:[$*]"
    Script=${scriptName} main_base "$@"
}

[[ -z ${sourceMe} ]] && main "$@"
