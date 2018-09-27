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


# SHELL DEFAULTS ----------------------------------------------------

BASEDIR="${HOME}"               # Location of includes dir
HISTCONTROL=ignoreboth          # Ignore duplicate/blank history
shopt -s histappend             # Don't overwrite history; append
HISTSIZE=1000                   # Shell history size
HISTFILESIZE=2000               # Shell history file size
shopt -s checkwinsize           # Update rows/cols if size changes
export VISUAL=nvim              # Set default visual editor
export EDITOR="${VISUAL}"       # Set default text editor
export TERM=screen-256color

# Include files loaded at end of this script
# Located in $BASEDIR
INCLUDES=(
".bash_aliases"                 # Aliases for all OSes
".bash_functions"               # General functions 
".bash_linux"                   # Code to run on Linux 
".bash_mac"                     # Code to run on Mac 
".bash_windows"                 # Code to run on Win (Git bash)
".bash_prompt"                  # Prompt-specific settings
# ".bash_colors"                # Color definitions (slow)
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

if [ "$DEBUG_MODE" == true ]; then
    echo "$(date +"%T.%3N"): Leaving .bashrc"
fi
