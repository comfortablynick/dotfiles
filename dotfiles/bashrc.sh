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
    Linux*)     OS_NAME=Linux;;
    Darwin*)    OS_NAME=Mac;;
    CYGWIN*)    OS_NAME=Windows;;
    MINGW*)     OS_NAME=Windows;;
    *)          OS_NAME="UNKNOWN:$(uname -s)"
esac
echo "Bash is logged into ${HOSTNAME} (${OS_NAME}) at ${START_TIME}"

[ "$DEBUG_MODE" == true ] && echo "$(date +"%T.%3N"): Entering .bashrc";


# SHELL DEFAULTS ----------------------------------------------------

stty -ixon                                                      # Disable ctrl-s and ctrl-q
stty icrnl
BASEDIR="${HOME}/dotfiles/dotfiles"                             # Location of includes dir
HISTCONTROL=ignoreboth                                          # Ignore duplicate/blank history
shopt -s histappend                                             # Don't overwrite history; append
HISTSIZE=                                                       # Shell history size
HISTFILESIZE=                                                   # Shell history file size
shopt -s checkwinsize                                           # Update rows/cols if size changes
shopt -s autocd                                                 # Auto cd if entering dir name at prompt
export XDG_CONFIG_HOME="$HOME/.config"                          # Some scripts look here

# Include files loaded at end of this script
# Located in $BASEDIR
INCLUDES=(
# "bash_aliases.sh"                                               # Aliases for all OSes
"bash_functions.sh"                                             # General functions
"bash_linux.sh"                                                 # Code to run on Linux
"bash_mac.sh"                                                   # Code to run on Mac
"bash_windows.sh"                                               # Code to run on Win (Git bash)
"bash_prompt.sh"                                                # Prompt-specific settings
# "bash_colors.sh"                                                # Color definitions (slow)
)

# EDITOR ------------------------------------------------------------
export VISUAL=nvim                                              # Set default visual editor
export EDITOR="${VISUAL}"                                       # Set default text editor

# Set vim compatibility if SSH connection
[ -n "$SSH_CONNECTION" ] && export VIM_SSH_COMPAT=1

# PROMPT ------------------------------------------------------------

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

#INCLUDES ------------------------------------------------------------

# Source all .bash files in snippets subdir
if [ -d ${BASEDIR}/.config/bash/conf.d ]; then
    for file in ${BASEDIR}/.config/bash/conf.d/*.bash; do
        [ "$DEBUG_MODE" == true ] && echo "$(date +"%T.%3N"): Sourcing ${file}"
        source $file
    done
fi
unset file

# Load includes if they exist; add timestamp for debug mode
for file in ${INCLUDES[@]}; do
    if [ -f $BASEDIR/$file ]; then
        [ "$DEBUG_MODE" == true ] && echo "$(date +"%T.%3N"): Sourcing ${file}"
        source $BASEDIR/$file
    fi
done
unset file

[ "$DEBUG_MODE" == true ] && echo "$(date +"%T.%3N"): Leaving .bashrc"
