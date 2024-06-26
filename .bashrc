#!/usr/bin/env bash
# vim:ft=sh fdl=1:
#    _               _
#   | |__   __ _ ___| |__  _ __ ___
#   | '_ \ / _` / __| '_ \| '__/ __|
#  _| |_) | (_| \__ \ | | | | | (__
# (_)_.__/ \__,_|___/_| |_|_|  \___|
#
# Init {{{1
# Return if non-interactive {{{2
[[ $- != *i* ]] && return

# Debug mode {{{2
START_TIME="$(date)"
export DEBUG_MODE=false

# Check OS {{{2
case "$(uname -s)" in
Linux*) OS_NAME=Linux ;;
Darwin*) OS_NAME=Mac ;;
CYGWIN*) OS_NAME=Windows ;;
MINGW*) OS_NAME=Windows ;;
*) OS_NAME="UNKNOWN:$(uname -s)" ;;
esac
echo "Bash is logged into ${HOSTNAME} (${OS_NAME}) at ${START_TIME}"

$DEBUG_MODE && echo "$(date +"%T.%3N"): Entering .bashrc"

# General config {{{1
# Shell options {{{2
stty -ixon # Disable ctrl-s and ctrl-q
stty icrnl
HISTCONTROL=ignoreboth # Ignore duplicate/blank history
shopt -s histappend    # Don't overwrite history; append
HISTSIZE=              # Shell history size
HISTFILESIZE=          # Shell history file size
shopt -s checkwinsize  # Update rows/cols if size changes
shopt -s autocd        # Auto cd if entering dir name at prompt

# Environment variables {{{2
export CURRENT_SHELL=bash
BASEDIR="${HOME}"             # Location of includes dir
export XDG_CONFIG_HOME="$HOME/.config" # Some scripts look her

# Functions {{{1
# cd :: wrapper for ls on cd {{{2
cd() {
    builtin cd "$@" && {
        if [[ $PWD != "$HOME" ]] && [[ $LS_AFTER_CD -eq 1 ]]; then
            ls -A --group-directories-first --color=always
        fi
    }
}

# cf :: fuzzy cd {{{2
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

fh() {
    local line
    shopt -u nocaseglob nocasematch
    line=$(
    history |
            sweep --reversed --nth=2.. --prompt='HISTORY' |
            command grep '^ *[0-9]'
    ) &&
        if [[ $- =~ H ]]; then
            sed 's/^ *\([0-9]*\)\** .*/!\1/' <<<"$line"
        else
            sed 's/^ *\([0-9]*\)\** *//' <<<"$line"
        fi
}

# Includes {{{1
# Source posix .sh config snippets {{{2
# shellcheck source=/dev/null
source "${XDG_CONFIG_HOME}/asdf-direnv/bashrc"

if [[ -d ${BASEDIR}/.config/shell/conf.d ]]; then
    for file in "${BASEDIR}"/.config/shell/conf.d/*.sh; do
        $DEBUG_MODE && echo "$(date +"%T.%3N"): Sourcing shell snippet: ${file}"
        # shellcheck source=/dev/null
        source "$file"
    done
fi

unset file

# Source .bash config snippets {{{2
if [[ -d ${BASEDIR}/.config/bash/conf.d ]]; then
    for file in "${BASEDIR}"/.config/bash/conf.d/*.bash; do
        $DEBUG_MODE && echo "$(date +"%T.%3N"): Sourcing bash snippet: ${file}"
        # shellcheck source=/dev/null
        source "$file"
    done
fi
unset file

# Source common shell functions {{{2
# if [[ -d ${BASEDIR}/.config/shell/functions ]]; then
#     for file in "${BASEDIR}"/.config/shell/functions/*; do
#         $DEBUG_MODE && echo "$(date +"%T.%3N"): Sourcing function snippet: ${file}"
#         # shellcheck source=/dev/null
#         source "$file"
#     done
# fi
# unset file

# Source .bash files in completions dir {{{2
if [[ -d ${BASEDIR}/.config/bash/completions ]]; then
    for file in "${BASEDIR}"/.config/bash/completions/*.bash; do
        $DEBUG_MODE && echo "$(date +"%T.%3N"): Sourcing completion: ${file}"
        # shellcheck source=/dev/null
        source "$file"
    done
fi
unset file

# OS-specific config {{{1
# Mac {{{2
if [[ ${OS_NAME} = "Mac" ]]; then

    # Enable color support of ls and read color conifg file
    [[ -f "${HOME}/.dircolors" ]] && eval "$(gdircolors "${HOME}/.dircolors")"

    # Setting PATH for coreutils
    PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

    # Language Defaults
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8

    # enable programmable completion features
    if ! shopt -oq posix; then
        if [[ -f /usr/share/bash-completion/bash_completion ]]; then
            # shellcheck source=/dev/null
            source /usr/share/bash-completion/bash_completion
        elif [[ -f /etc/bash_completion ]]; then
            # shellcheck source=/dev/null
            sourcee/etc/bash_completion
        fi
    fi

    # Show/hide hidden files
    function togglehidden() {
        ISHIDDEN=$(defaults read com.apple.finder AppleShowAllFiles)
        if [[ $ISHIDDEN = true ]]; then
            defaults write com.apple.finder AppleShowAllFiles FALSE
        else
            defaults write com.apple.finder AppleShowAllFiles TRUE
        fi
        killall Finder
    }
fi

# Linux {{{2
if [[ ${OS_NAME} = "Linux" ]]; then

    # Colored man pages
    export MANROFFOPT='-c'

    LESS_TERMCAP_mb=$(
        tput bold
        tput setaf 2
    )
    LESS_TERMCAP_md=$(
        tput bold
        tput setaf 6
    )
    LESS_TERMCAP_me=$(tput sgr0)
    LESS_TERMCAP_so=$(
        tput bold
        tput setaf 3
        tput setab 4
    )
    LESS_TERMCAP_se=$(
        tput rmso
        tput sgr0
    )
    LESS_TERMCAP_us=$(
        tput smul
        tput bold
        tput setaf 7
    )
    LESS_TERMCAP_ue=$(
        tput rmul
        tput sgr0
    )
    LESS_TERMCAP_mr=$(tput rev)
    LESS_TERMCAP_mh=$(tput dim)

    export LESS_TERMCAP_mb
    export LESS_TERMCAP_md
    export LESS_TERMCAP_me
    export LESS_TERMCAP_so
    export LESS_TERMCAP_se
    export LESS_TERMCAP_us
    export LESS_TERMCAP_ue
    export LESS_TERMCAP_mr
    export LESS_TERMCAP_mh
fi
# Prompt {{{1
# Prompt selection {{{2
# uses first one that -eq 1, or default if none
USE_ENHANCED_GIT_PROMPT=0 # Enhanced Git Prompt
USE_GITPR_GIT_PROMPT=0    # Gitpr-based prompt
USE_STARSHIP_PROMPT=1     # Use starship prompt written in rust

# Enhanced git prompt {{{2
export GIT_PROMPT_ONLY_IN_REPO=0             # Set config variables first
export GIT_PROMPT_IGNORE_SUBMODULES=1        # avoid searching for changed files in submodules
export GIT_PROMPT_SHOW_UNTRACKED_FILES=no    # can be no, normal or all; determines counting of untracked files
export GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # avoid printing the number of changed files
# export GIT_PROMPT_WITH_VIRTUAL_ENV=0       # avoid setting virtual environment infos for node/python/conda environments
# export GIT_PROMPT_SHOW_UPSTREAM=1          # show upstream tracking branch
# export GIT_PROMPT_FETCH_REMOTE_STATUS=0    # avoid fetching remote status
# export GIT_PROMPT_START=...                # custom prompt start sequence
# export GIT_PROMPT_END=...                  # custom prompt end sequence
# export GIT_PROMPT_THEME_FILE=$XDG_CONFIG_HOME/shell/bash-git-prompt/Custom.bgptemplate

if [[ $USE_ENHANCED_GIT_PROMPT -eq 1 ]]; then
    if [ ! -d "$HOME/.bash-git-prompt" ]; then
        git clone https://github.com/magicmonty/bash-git-prompt.git "$HOME/.bash-git-prompt"
    fi
    # source bash-git-prompt
    # shellcheck source=/dev/null
    if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
        source "$HOME/.bash-git-prompt/gitprompt.sh"
    fi

# Custom git-enabled prompt using gitpr {{{2
elif [[ $USE_GITPR_GIT_PROMPT -eq 1 ]]; then
    PROMPT_COMMAND="_gitpr_prompt_command; $PROMPT_COMMAND"
    _gitpr_prompt_command() {
        curr_exit="$?"
        cmd_err_glyph='✘'
        cmd_ok_glyph='✔'
        gitpr="$(gitpr -sq 2>/dev/null)"
        date="$(date +%H:%M)"

        # Exit status
        [ $curr_exit -eq 0 ] && PS1="$GREEN\$cmd_ok_glyph" || PS1="$RED\$cmd_err_glyph-\$curr_exit"

        # user@host (if not in tmux)
        [ -z "$TMUX_PANE" ] && PS1="$PS1$BOLDGREEN\u@\h$DEFAULT: "

        # CWD and git repo info
        PS1="$PS1 $YELLOW\w $DEFAULT\$gitpr\n"

        # Second line
        # Virtualenv name if active, else current time
        PS1="$PS1$GRAY"
        [ -n "$VIRTUAL_ENV" ] && PS1="$PS1(${VIRTUAL_ENV##*/})" || PS1="$PS1\$date"
        PS1="$PS1$DEFAULT \$ "
    }

# Starship prompt {{{2
elif [[ $USE_STARSHIP_PROMPT -eq 1 ]] && command -v starship &>/dev/null; then
    eval "$(starship init bash)"

# Default git color prompt {{{2
else
    # Color definitions {{{3
    DEFAULT="\[\033[0;00m\]"
    BOLDGREEN="\[\033[01;32m\]"
    GREEN="\[\033[0;32m\]"
    YELLOW="\[\033[0;33m\]"
    RED="\[\033[0;31m\]"
    CYAN="\[\033[0;36m\]"
    GRAY="\[\033[0;37m\]"
    # BOLDBLUE="\[\033[01;34m\]"

    # Functions {{{3
    find_git_branch() { # {{{4
        # Based on: http://stackoverflow.com/a/13003854/170413
        local branch
        if branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); then
            if [ "$branch" == "HEAD" ]; then
                branch='detached*'
            fi
            git_branch="($branch)"
        else
            git_branch=""
        fi
    }

    find_git_dirty() { # {{{4
        local status
        status=$(git status --porcelain 2>/dev/null)
        if [ -n "$status" ]; then
            git_dirty='*'
        else
            git_dirty=''
        fi
    }

    virtualenv_info() { # {{{4
        if [ -n "$VIRTUAL_ENV" ]; then
            venv_name="(${VIRTUAL_ENV##*/})"
        else
            venv_name=""
        fi
    }

    PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"
    export PS1="$venv_name$BOLDGREEN\u@\h$DEFAULT: $YELLOW\w $CYAN\$git_branch$RED\$git_dirty$DEFAULT\n\$ "
fi

$DEBUG_MODE && echo "$(date +"%T.%3N"): Leaving .bashrc"
