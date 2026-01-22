#!/bin/bash

function parse_host_suffix {
    # What sort of unix variant/flavor are we?
    if [[ -n $PS1_HOST_SUFFIX ]]; then
        echo "$PS1_HOST_SUFFIX"
        return;
    fi
    [[ -n $PS1_SUPPRESS_HOST_SUFFIX ]] \
        && return
    if [[ "${SPACES__ENV:-}" == yes ]]; then
        PS1_HOST_SUFFIX='Spaces';
        echo "$PS1_HOST_SUFFIX";
        return;
    fi
    [[ -f /.dockerenv ]] && {
        PS1_HOST_SUFFIX='Docker';
        echo $PS1_HOST_SUFFIX;
        return;
    }
    grep -sq docker /proc/1/cgroup && {
        PS1_HOST_SUFFIX='Docker';
        echo $PS1_HOST_SUFFIX;
        return;
    }

    case $(uname -a) in
        Darwin*)
            PS1_HOST_SUFFIX='Mac'; echo $PS1_HOST_SUFFIX; return
            ;;
        Linux*-WSL2*)
            if [[ -n "${WSL_DISTRO_NAME}" ]]; then
                PS1_HOST_SUFFIX="${WSL_DISTRO_NAME}"
            else
                PS1_HOST_SUFFIX='Wsl2';
            fi
            echo "$PS1_HOST_SUFFIX" ;
            return
            ;;
        Linux*-Microsoft*)
            PS1_HOST_SUFFIX='Wsl1'; echo $PS1_HOST_SUFFIX ; return
            ;;
        CYGWIN*)
            PS1_HOST_SUFFIX='Cyg'; echo $PS1_HOST_SUFFIX ; return
            ;;
        MINGW*)
            PS1_HOST_SUFFIX='Gitb'; echo $PS1_HOST_SUFFIX ; return
            ;;
        # Other platform-type detections can be added here:
    esac
    if which lsb_release &>/dev/null; then
        if lsb_release -a 2>/dev/null | grep -Eq 'RedHat'; then
            PS1_HOST_SUFFIX='rhat'; echo $PS1_HOST_SUFFIX; return
        fi
    fi
    PS1_HOST_SUFFIX='Generic'  # undetected
    echo $PS1_HOST_SUFFIX
}

parse_host_suffix
