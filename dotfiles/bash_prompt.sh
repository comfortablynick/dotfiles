#!/usr/bin/env bash
# GIT-AWARE PROMPT

[ "$OS_NAME" = "Windows" ] && return

# Prompt functions {{{1
find_git_branch() { # {{{2
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

find_git_dirty() { # {{{2
    local status=$(git status --porcelain 2>/dev/null)
    if [ -n "$status" ]; then
        git_dirty='*'
    else
        git_dirty=''
    fi
}

exit_status() { # {{{2
    local status=$?
    if [ $status -eq 0 ]; then
        prompt_color=$GREEN
    else
        prompt_color=$RED
    fi
}

virtualenv_info() { # {{{2
    if [ -n "$VIRTUAL_ENV" ]; then
        venv_name="(${VIRTUAL_ENV##*/})\n"
    else
        venv_name=""
    fi
}

_gitpr() { #{{{2
    gitpr="$(gitpr -f '(%b) %m' 2>/dev/null)"
}

# Enhanced git prompt {{{1
# GIT_PROMPT_THEME_FILE=$XDG_CONFIG_HOME/shell/bash-git-prompt/Custom.bgptemplate
USE_ENHANCED_GIT_PROMPT=0             # Enhanced Git Prompt
GIT_PROMPT_ONLY_IN_REPO=0             # Set config variables first
# GIT_PROMPT_FETCH_REMOTE_STATUS=0    # avoid fetching remote status
GIT_PROMPT_IGNORE_SUBMODULES=1        # avoid searching for changed files in submodules
# GIT_PROMPT_WITH_VIRTUAL_ENV=0       # avoid setting virtual environment infos for node/python/conda environments
# GIT_PROMPT_SHOW_UPSTREAM=1          # show upstream tracking branch
GIT_PROMPT_SHOW_UNTRACKED_FILES=no    # can be no, normal or all; determines counting of untracked files
GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # avoid printing the number of changed files
# GIT_PROMPT_START=...                # custom prompt start sequence
# GIT_PROMPT_END=...                  # custom prompt end sequence

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ] && [ $USE_ENHANCED_GIT_PROMPT -eq 1 ]; then
    source "$HOME/.bash-git-prompt/gitprompt.sh"
    return
fi

# Default Git enabled prompt {{{1
DEFAULT="\[\033[0;00m\]"
BOLDGREEN="\[\033[01;32m\]"
BOLDBLUE="\[\033[01;34m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
RED="\[\033[0;31m\]"
CYAN="\[\033[0;36m\]"

PROMPT_COMMAND=_prompt_command

_prompt_command() {
    curr_exit="$?"
    gitpr="$(gitpr -f '(%b) %m' 2>/dev/null)"

    PS1="\$venv_name$BOLDGREEN\u@\h$DEFAULT: $YELLOW\w $DEFAULT\$gitpr"

    if [ $curr_exit -eq 0 ]; then
        PS1="$PS1\n\$ $DEFAULT"
    else
        PS1="$PS1 $YELLOW(\$curr_exit)\n\$ $DEFAULT"
    fi
}

# standard git-aware prompt with color
# PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"
# export PS1="$venv_name$BOLDGREEN\u@\h$DEFAULT: $YELLOW\w $CYAN\$git_branch$RED\$git_dirty$DEFAULT\n\$ "

# use gitpr rust program
# PROMPT_COMMAND="_gitpr; exit_status; $PROMPT_COMMAND"
# export PS1="\$venv_name$BOLDGREEN\u@\h$DEFAULT: $YELLOW\w $DEFAULT\$gitpr\n\$prompt_color\$$DEFAULT "

# # Powerline (not used) {{{1
# if [ "$POWERLINE_ROOT" != "" ]; then
#     if [ -f "${POWERLINE_ROOT}/bindings/bash/powerline.sh" ]; then
#         # if [ command -v powerline-daemon 2>/dev/null ]; then
#         powerline-daemon -q
#         POWERLINE_BASH_CONTINUATION=1
#         POWERLINE_BASH_SELECT=1
#         . "${POWERLINE_ROOT}/bindings/bash/powerline.sh"
#     fi
# fi
# vim:fdm=marker:
