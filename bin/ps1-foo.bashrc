# ps1-foo.bashrc


function parse_lh_status {
    [[ -z $HISTFILE ]] && return;
    [[ $HISTFILE == ~/.bash_history ]] && return
    echo -n "+H"
}

function parse_ext_tail {
    # If we've shelled-out from vi/vim, we want to know about it to avoid chaos:
    if [[ -n $VIM ]]; then
        echo -n '[vi]'
        return
    elif [[ -n $bbproxy_shell_ps1 ]]; then
        echo -n '[bbproxy]'
        return
    fi
}

function t_setFancyPs1 {
    type -t parse_git_branch  &>/dev/null || {
        # parse_git_branch can be externally defined.  If it's not, we
        # stub it out:
        parse_git_branch() { :; }
    }

    PROMPT_DIRTRIM=3
    # NOTE: to avoid problems with cursor positioning due to fancy PS1,
    # be aware of the need to escape non-printing chars (see https://stackoverflow.com/a/19501528/237059)
PS1='
\[\033[1;33m\][\D{%m-%d %H:%M.%S}]\[\033[0m\] \[\033[1;35m\]\w\[\033[0m\]$(parse_git_branch)
\[\033[1;36m\][\u $(parse_ps1_host_suffix.sh) \h]\[\033[0m\]$(parse_ext_tail)$Ps1Tail$(parse_lh_status)> '
}

t_setFancyPs1
