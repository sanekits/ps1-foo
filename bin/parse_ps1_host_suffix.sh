#!/bin/bash

function parse_host_suffix {
    # What sort of unix variant/flavor are we?
    [[ -n $PS1_HOST_SUFFIX ]] && {
        echo $PS1_HOST_SUFFIX;
        return;
    }
    [[ -n $PS1_SUPPRESS_HOST_SUFFIX ]] \
        && return
    grep -sq code-server-init /proc/1/cmdline 2>/dev/null && {
        PS1_HOST_SUFFIX='Spaces';
        echo "$PS1_HOST_SUFFIX";
        return;
    }
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
            [[ -n "${WSL_DISTRO_NAME}" ]] && {
                PS1_HOST_SUFFIX="${WSL_DISTRO_NAME}"
            } || {
                PS1_HOST_SUFFIX='Wsl2';
            }
            echo $PS1_HOST_SUFFIX ;
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
        if lsb_release -a 2>/dev/null | egrep -q 'RedHat'; then
            PS1_HOST_SUFFIX='rhat'; echo $PS1_HOST_SUFFIX; return
        fi
    fi
    PS1_HOST_SUFFIX='Generic'  # undetected
    echo $PS1_HOST_SUFFIX
}

parse_host_suffix
