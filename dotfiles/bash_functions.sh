#!/usr/bin/env bash
# Helpful bash scripts; loaded by .bashrc
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

