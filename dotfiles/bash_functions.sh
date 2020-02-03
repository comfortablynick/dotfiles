#!/usr/bin/env bash
# Helpful bash scripts; loaded by .bashrc
# For: funcs available at all times (not loaded in $PATH)

# Reset the terminal and source .bashrc
reload() {
    reset
    export DEBUG_MODE=false
    source ${HOME}/.bashrc
}

# Reset and print elapsed time for debugging
brel() {
    reset
    if [ "$1" == "d" ]; then
        export DEBUG_MODE=true
    else
        export DEBUG_MODE=false
    fi
    time . "${HOME}/.bashrc"
}

# Easily print timestamp
timestamp() {
    date +"%T"
}

# is_ssh :: Return true if in SSH session
is_ssh() {
    if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]]; then
        return 0
    else
        return 1
    fi
}

# is_mosh :: Return true if in Mosh session
is_mosh() {
    local tmux_current_session tmux_client_id pid mosh_found
    if [[ -n $TMUX ]]; then
        # current shell is under tmux
        tmux_current_session=$(tmux display-message -p '#S')
        tmux_client_id=$(tmux list-clients -t "${tmux_current_session}" -F '#{client_pid}')
        pid="$tmux_client_id"
    else
        pid="$$"
    fi
    mosh_found=$(pstree -ps $pid | grep mosh-server) # or empty if not found
    if [[ -z $mosh_found ]]; then
        return 1 # exit code 1: not mosh
    fi
    return 0 # exit code 0: is mosh
}

# wrapper for cd builtin
# show directory contents if not $HOME
cd() {
    builtin cd "$@" && {
        if [[ $PWD != "$HOME" ]] || [[ $LS_AFTER_CD -eq 1 ]]; then
            ls --group-directories-first
        fi
    }
}

# cf :: fuzzy cd
cf() {
    local file

    # file="$(locate -Ai -0 "$@" | grep -z -vE '~$' | fzf --read0 -0 -1)"
    # file="$(locate -Ai "$@" | rg -vP '~$' | fzy)"
    file="$(fd "$@" -t d | fzy)"

    if [[ -n $file ]]; then
        if [[ -d $file ]]; then
            cd -- "$file" || return
        else
            cd -- "${file:h}" || return
        fi
    fi
}
