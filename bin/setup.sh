#!/bin/bash
# setup.sh for ps1-foo

die() {
    echo "ERROR: $@" >&2
    exit 1
}

canonpath() {
    ( cd -L -- "$(dirname -- $0)"; echo "$(pwd -P)/$(basename -- $0)" )
}

Script=$(canonpath "$0")
Scriptdir=$(dirname -- "$Script")
reload_reqd=false

source ${Scriptdir}/shellkit/shellkit_setup_base || die Failed sourcing shellkit_base

shrc_fixup() {
    # We must ensure that .bashrc sources our ps1-foo.bashrc script
    (
        # Each kit defines a [Kitname]-semaphore function which just prints '1'
        /bin/bash -l -c "type -f ${Kitname}-semaphore >/dev/null"
    ) &>/dev/null
    [[ $? -eq 0 ]] && {
        return
    }

    ( # Add hook to .bashrc
        echo "[[ -n \$PS1 && -f \${HOME}/.local/bin/${Kitname}/${Kitname}.bashrc ]] && source \${HOME}/.local/bin/${Kitname}/${Kitname}.bashrc # Added by ${Kitname}-setup.sh"
        echo
    ) >> ${HOME}/.bashrc
    reload_reqd=true
}


main() {
    if [[ ! -d $HOME/.local/bin/ps1-foo ]]; then
        if [[ -e $HOME/.local/bin/ps1-foo ]]; then
            die "$HOME/.local/bin/ps1-foo exists but is not a directory.  Refusing to overwrite"
        fi
        command mkdir -p $HOME/.local/bin/ps1-foo || die "Failed creating $HOME/.local/bin/ps1-foo"
    fi
    if [[ $(inode $Script) -eq $(inode ${HOME}/.local/bin/ps1-foo/setup.sh) ]]; then
        die "cannot run setup.sh from ${HOME}/.local/bin"
    fi
    builtin cd ${HOME}/.local/bin/ps1-foo || die "101"
    command rm -rf ./* || die "102"
    [[ -d ${Scriptdir} ]] || die "bad Scriptdir [$Scriptdir]"
    command cp -r ${Scriptdir}/* ./ || die "failed copying from ${Scriptdir} to $PWD"
    builtin cd .. # Now we're in .local/bin
    command ln -sf ./ps1-foo/ps1-foo-version.sh ./ || die "101.5"
    command ln -sf ./ps1-foo/parse_ps1_host_suffix.sh ./ || die "101.6"
    path_fixup_local_bin ps1-foo || die "102"
    shrc_fixup || die "104"
    $reload_reqd && builtin echo "Shell reload required ('bash -l')" >&2
}

[[ -z $sourceMe ]] && main "$@"
