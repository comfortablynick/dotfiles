#!/usr/bin/env bash
#     _             _           
#    | |__  __ _ __| |_  _ _ __ 
#   _| '_ \/ _` (_-< ' \| '_/ _|
#  (_)_.__/\__,_/__/_||_|_| \__|
#

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

# Location of includes
BASEDIR="${HOME}"

# Filnames to include
INCLUDES=(".bash_colorsx" ".bash_aliases" ".bash_prompt" ".bash_functions" ".bash_linux" ".bash_mac" ".bash_windows")

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set default editor
export VISUAL=nvim
export EDITOR="${VISUAL}"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability 
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

# Load includes if they exist; add timestamp for debug mode
for file in ${INCLUDES[@]}; do
    if [ -f $BASEDIR/$file ]; then
        [ "$DEBUG_MODE" == true ] && echo "$(date +"%T.%3N"): Sourcing ${file}"
        source $BASEDIR/$file
    fi
done
unset file

if [ "$DEBUG_MODE" == true ]; then
    echo "$(date +"%T.%3N"): Leaving .bashrc"
fi
