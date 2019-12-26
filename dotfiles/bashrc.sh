#!/usr/bin/env bash
#    _               _
#   | |__   __ _ ___| |__  _ __ ___
#   | '_ \ / _` / __| '_ \| '__/ __|
#  _| |_) | (_| \__ \ | | | | | (__
# (_)_.__/ \__,_|___/_| |_|_|  \___|

# If not running interactively exit
[[ $- != *i* ]] && return

START_TIME="$(date)"

# Check OS
case "$(uname -s)" in
Linux*) OS_NAME=Linux ;;
Darwin*) OS_NAME=Mac ;;
CYGWIN*) OS_NAME=Windows ;;
MINGW*) OS_NAME=Windows ;;
*) OS_NAME="UNKNOWN:$(uname -s)" ;;
esac
echo "Bash is logged into ${HOSTNAME} (${OS_NAME}) at ${START_TIME}"

[ "$DEBUG_MODE" = true ] && echo "$(date +"%T.%3N"): Entering .bashrc"

# SHELL DEFAULTS ----------------------------------------------------

stty -ixon # Disable ctrl-s and ctrl-q
stty icrnl
BASEDIR="${HOME}/dotfiles/dotfiles"    # Location of includes dir
HISTCONTROL=ignoreboth                 # Ignore duplicate/blank history
shopt -s histappend                    # Don't overwrite history; append
HISTSIZE=                              # Shell history size
HISTFILESIZE=                          # Shell history file size
shopt -s checkwinsize                  # Update rows/cols if size changes
shopt -s autocd                        # Auto cd if entering dir name at prompt
export XDG_CONFIG_HOME="$HOME/.config" # Some scripts look here

# Include files loaded at end of this script
# Located in $BASEDIR
INCLUDES=(
    "bash_functions.sh" # General functions
    "bash_mac.sh"       # Code to run on Mac
    "bash_windows.sh"   # Code to run on Win (Git bash)
    "bash_prompt.sh"    # Prompt-specific settings
)

# Set vim compatibility if SSH connection
#INCLUDES ------------------------------------------------------------

# Source all .bash files in config snippets subdir
if [[ -d ${BASEDIR}/.config/bash/conf.d ]]; then
    for file in "${BASEDIR}"/.config/bash/conf.d/*.bash; do
        [[ $DEBUG_MODE ]] && echo "$(date +"%T.%3N"): Sourcing snippet: ${file}"
        source "$file"
    done
fi
unset file

# Source all .bash files in completions dir
if [[ -d ${BASEDIR}/.config/bash/completions ]]; then
    for file in "${BASEDIR}"/.config/bash/completions/*.bash; do
        [[ $DEBUG_MODE ]] && echo "$(date +"%T.%3N"): Sourcing completion: ${file}"
        source "$file"
    done
fi
unset file

# Load includes if they exist; add timestamp for debug mode
for file in "${INCLUDES[@]}"; do
    if [[ -f $BASEDIR/$file ]]; then
        [[ $DEBUG_MODE ]] && echo "$(date +"%T.%3N"): Sourcing ${file}"
        source "$BASEDIR/$file"
    fi
done
unset file

# mosh/ssh detection
if is_mosh; then
    export VIM_SSH_COMPAT=1
fi

# BEGIN ANSIBLE MANAGED BLOCK: asdf
if [[ -e $HOME/.asdf/asdf.sh ]]; then
    source "$HOME/.asdf/asdf.sh"
    source "$HOME/.asdf/completions/asdf.bash"
fi
# END ANSIBLE MANAGED BLOCK: asdf

[[ $DEBUG_MODE ]] && echo "$(date +"%T.%3N"): Leaving .bashrc"
