#!/usr/bin/env bash
# GIT-AWARE PROMPT

[ "$OS_NAME" = "Windows" ] && return;

find_git_branch() {
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

find_git_dirty() {
    local status=$(git status --porcelain 2>/dev/null)
    if [ -n "$status" ]; then
        git_dirty='*'
    else
        git_dirty=''
    fi
}

virtualenv_info() {
    if [ -n "$VIRTUAL_ENV" ]; then
        venv_name="(${VIRTUAL_ENV##*/})\n"
    else
        venv_name=""
    fi
}

_gitpr() {
    gitpr="$(gitpr -f '%g %b %a %m %d %u %s' 2>/dev/null)"
}

# export VIRTUAL_ENV_DISABLE_PROMPT=yes

# Enhanced Git Prompt
USE_ENHANCED_GIT_PROMPT=1

# Set config variables first
GIT_PROMPT_ONLY_IN_REPO=0

# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status
GIT_PROMPT_IGNORE_SUBMODULES=1        # uncomment to avoid searching for changed files in submodules
# GIT_PROMPT_WITH_VIRTUAL_ENV=0 # uncomment to avoid setting virtual environment infos for node/python/conda environments
# GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
GIT_PROMPT_SHOW_UNTRACKED_FILES=no    # can be no, normal or all; determines counting of untracked files

GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=0 # uncomment to avoid printing the number of changed files

# GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
# GIT_PROMPT_END=...      # uncomment for custom prompt end sequence

# as last entry source the gitprompt script
# GIT_PROMPT_THEME=Default_Ubuntu
GIT_PROMPT_THEME_FILE=$XDG_CONFIG_HOME/shell/bash-git-prompt/Custom.bgptemplate
# GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" -a $USE_ENHANCED_GIT_PROMPT -eq 1 ]; then
    source "$HOME/.bash-git-prompt/gitprompt.sh"
else
    # Default Git enabled prompt with dirty state
    DEFAULT="\[\033[0;00m\]"
    BOLDGREEN="\[\033[01;32m\]"
    BOLDBLUE="\[\033[01;34m\]"
    GREEN="\[\033[0;32m\]"
    YELLOW="\[\033[0;33m\]"
    RED="\[\033[0;31m\]"
    CYAN="\[\033[0;36m\]"


    # standard git-aware prompt with color
    # PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"
    # export PS1="$virtualenv_info$BOLDGREEN\u@\h$DEFAULT: $YELLOW\w $CYAN\$git_branch$RED\$git_dirty$DEFAULT\n\$ "

    # use gitpr rust program
    PROMPT_COMMAND="_gitpr; $PROMPT_COMMAND"
    export PS1="\$venv_name$BOLDGREEN\u@\h$DEFAULT: $YELLOW\w $DEFAULT\$gitpr\n\$ "
fi

return

# Powerline (not used)
if [ "$POWERLINE_ROOT" != "" ]; then
    if [ -f "${POWERLINE_ROOT}/bindings/bash/powerline.sh" ]; then
        # if [ command -v powerline-daemon 2>/dev/null ]; then
        powerline-daemon -q
        POWERLINE_BASH_CONTINUATION=1
        POWERLINE_BASH_SELECT=1
        . "${POWERLINE_ROOT}/bindings/bash/powerline.sh"
    fi
fi
