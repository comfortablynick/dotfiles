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
export VISUAL=nvim                                              # Set default visual editor
export EDITOR="${VISUAL}"                                       # Set default text editor
export XDG_CONFIG_HOME="$HOME/.config"                          # Some scripts look here

# Include files loaded at end of this script
# Located in $BASEDIR
INCLUDES=(
"bash_aliases.sh"                                               # Aliases for all OSes
"bash_functions.sh"                                             # General functions
"bash_linux.sh"                                                 # Code to run on Linux
"bash_mac.sh"                                                   # Code to run on Mac
"bash_windows.sh"                                               # Code to run on Win (Git bash)
"bash_prompt.sh"                                                # Prompt-specific settings
# "bash_colors.sh"                                              # Color definitions (slow)
)

# PROMPT ------------------------------------------------------------

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi


#INCLUDES ------------------------------------------------------------

# Load includes if they exist; add timestamp for debug mode
for file in ${INCLUDES[@]}; do
    if [ -f $BASEDIR/$file ]; then
        [ "$DEBUG_MODE" == true ] && echo "$(date +"%T.%3N"): Sourcing ${file}"
        source $BASEDIR/$file
    fi
done
unset file

# Source all .bash files in functions subdir
# TODO: combine with "INCLUDES" section
if [ -d ${BASEDIR}/.config/bash/functions ]; then
    for file in ${BASEDIR}/.config/bash/functions/*.bash; do
        [ "$DEBUG_MODE" == true ] && echo "$(date +"%T.%3N"): Sourcing ${file}"
        source $file
    done
fi
unset file

# Source local env file
file="${HOME}/env.sh"
if [ -f "${file}" ]; then
    [ "$DEBUG_MODE" == true ] && echo "$(date +"%T.%3N"): Sourcing ${file}"
    source $file
fi
unset file

if [ "$DEBUG_MODE" == true ]; then
    echo "$(date +"%T.%3N"): Leaving .bashrc"
fi
