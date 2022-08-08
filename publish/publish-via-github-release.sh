#!/bin/bash
# publish/publish-via-github-release.sh


Script=$(command readlink -f $0)
Scriptdir=$(command dirname $Script)
Kitname=$(cat $(readlink -f ${Scriptdir}/../bin/Kitname))


die() {
    builtin echo "ERROR: $@" >&2
    builtin exit 1
}

if [[ -z $sourceMe ]]; then
    [[ -n $Kitname ]] || die 99
    builtin cd ${Scriptdir}/../bin || die 100
    if [[ $( command git status -s . | command wc -l 2>/dev/null) -gt 0 ]]; then
        die "One or more files in $PWD need to be committed before publish"
    fi
    command git rev-parse HEAD > ./hashfile || die 104
    builtin cd ${Scriptdir}/.. || die 101
    version=$( bin/ps1-foo-version.sh | cut -f2)
    [[ -z $version ]] && die 103

    command mkdir -p ./tmp

    destFile=$PWD/tmp/ps1-foo-setup-${version}.sh
    command makeself.sh --follow --base64 $PWD/bin $destFile "ps1-foo ${version}" ./setup.sh  || die # [src-dir] [dest-file] [label] [setup-command]
    (
        cd $(dirname $destFile) && ln -sf $(basename $destFile) latest.sh
    )
    [[ $? -eq 0 ]] && echo "Done: upload $PWD/tmp/ps1-foo-setup-${version}.sh to Github release page (https://github.com/sanekits/ps1-foo/releases)"
fi
