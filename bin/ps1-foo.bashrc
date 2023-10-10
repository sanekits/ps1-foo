# ps1-foo.bashrc - shell init file for ps1-foo sourced from ~/.bashrc

ps1-foo-semaphore() {
    # shpm detects wth this function
    [[ 1 -eq  1 ]]
}

parse_lh_status() {
    # +H indicates a local history file is active
    [[ -z $HISTFILE ]] && return;
    [[ -z $DEFAULT_HISTFILE ]] && {
        local DEFAULT_HISTFILE=~/.bash_history;
    }
    [[ $HISTFILE == $DEFAULT_HISTFILE ]] && return
    echo -n "+H"
}

parse_ext_tail() {
    # If we've shelled-out from vi/vim, we want to know about it to avoid chaos:
    [[ -n $VIM ]] && {
        echo -n '[vi]'
        return
    }
}

parse_ps1_host_suffix() {
    [[ -x ~/.local/bin/parse_ps1_host_suffix.sh ]] &&  {
        ~/.local/bin/parse_ps1_host_suffix.sh 2>/dev/null
    }
}

t_setFancyPs1() {
    [ $? -eq 0 ] && local prevResult=true || prevResult=false
    local prevResultInd
    if $prevResult; then
        prevResultInd=$(printf "\[\033[01;32m\]""\xE2\x9C\x93""\[\033[;0m\]")
    else
        prevResultInd=$(printf "\[\033[01;31m\]""\xE2\x9C\x95""\[\033[;0m\]")
    fi
    # Set the PS1 variable on shell init:
    type -t parse_git_branch  &>/dev/null || {
        # parse_git_branch can be externally defined.  If it's not, we
        # stub it out:
        parse_git_branch() { :; }
    }

    PROMPT_DIRTRIM=3

    # NOTE: to avoid problems with cursor positioning due to fancy PS1,
    # be aware of the need to escape non-printing chars (see https://stackoverflow.com/a/19501528/237059)
    # That's what makes the prompt so hard to read.
PS1="
\[\033[1;33m\][\D{%m-%d %H:%M.%S}]\[\033[0m\] \[\033[1;35m\]\w\[\033[0m\]$(parse_git_branch)
\[\033[1;36m\][\u $(parse_ps1_host_suffix) \h]\[\033[0m\]$(parse_ext_tail)$Ps1Tail$(parse_lh_status)${prevResultInd}> "
    $prevResult;  # Important to reset prev result in case of chained prompt commands
}

source ~/.local/bin/ps1-foo/prompt-command-wrap.bashrc

__pcwrap_register t_setFancyPs1

