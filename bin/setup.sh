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
inode() {
    ( command ls -i "$1" | command awk '{print $1}') 2>/dev/null
}

is_on_path() {
    local tgt_dir="$1"
    [[ -z $tgt_dir ]] && { true; return; }
    local vv=( $(echo "${PATH}" | tr ':' '\n') )
    for v in ${vv[@]}; do
        if [[ $tgt_dir == $v ]]; then
            return
        fi
    done
    false
}

path_fixup() {
    # Add ~/.local/bin to the PATH if it's not already.  Modify
    # either .bash_profile or .profile honoring bash startup rules.
    local tgt_dir="$1"
    if is_on_path "${tgt_dir}"; then
        return
    fi
    (
        cd $HOME
        local profile=.bash_profile
        [[ -f $profile ]] || profile=.profile
        tmp_profile="profile-tmp.$$"
        echo 'export PATH=$HOME/.local/bin:$PATH # Added by ps1-foo-setup.sh' > "${tmp_profile}" || die 202
        [[ -e $profile ]] && cat $profile >> "${tmp_profile}"
        mv $tmp_profile $profile || die 203
        echo "WARNING: ~/.local/bin was added to your PATH by modifying ${PWD}/${profile}.  It is up to you to ensure that the contents of ~/.local/bin are benign!" >&2
    )
    reload_reqd=true
}

shrc_fixup() {
    # We must ensure that .bashrc sources our ps1-foo.bashrc script
    (
        unset ps1_foo_semaphore
        source ~/.bashrc
        type -f ps1_foo_semaphore
    ) &>/dev/null
    [[ $? -eq 0 ]] && {
        return
    }

    (
        echo '[[ -n $PS1 && -f ${HOME}/.local/bin/ps1-foo/ps1-foo.bashrc ]] && source ${HOME}/.local/bin/ps1-foo/ps1-foo.bashrc # Added by ps1-foo-setup.sh'
        echo
    ) >> ${HOME}/.bashrc
    reload_reqd=true
}


main() {
    reload_reqd=false
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
    path_fixup "$PWD" || die "102"
    shrc_fixup || die "104"
    $reload_reqd && builtin echo "Shell reload required ('bash -l')" >&2
}

[[ -z $sourceMe ]] && main "$@"
