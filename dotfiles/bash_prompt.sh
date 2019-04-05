#!/usr/bin/env bash

# Check interactive session {{{1
[ "$OS_NAME" = "Windows" ] && return
# Prompt selection {{{1
USE_ENHANCED_GIT_PROMPT=0 # Enhanced Git Prompt
USE_FACTORY_GIT_PROMPT=0  # Git prompt that comes with git cli

# Prompt colors {{{1
DEFAULT="\[\033[0;00m\]"
BOLDGREEN="\[\033[01;32m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
RED="\[\033[0;31m\]"
CYAN="\[\033[0;36m\]"
GRAY="\[\033[0;37m\]"
# BOLDBLUE="\[\033[01;34m\]"

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
    local status
    status=$(git status --porcelain 2>/dev/null)
    if [ -n "$status" ]; then
        git_dirty='*'
    else
        git_dirty=''
    fi
}

virtualenv_info() { # {{{2
    if [ -n "$VIRTUAL_ENV" ]; then
        venv_name="(${VIRTUAL_ENV##*/})"
    else
        venv_name=""
    fi
}

# Enhanced git prompt {{{1
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

if [ "$USE_ENHANCED_GIT_PROMPT" -eq 1 ]; then
    if [ ! -d "$HOME/.bash-git-prompt" ]; then
        git clone https://github.com/magicmonty/bash-git-prompt.git "$HOME/.bash-git-prompt"
    fi
    # source bash-git-prompt
    # shellcheck source=/dev/null
    [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ] &&
        source "$HOME/.bash-git-prompt/gitprompt.sh" &&
        return
fi

# Factory git color prompt {{{1
if [ "$USE_FACTORY_GIT_PROMPT" -eq 1 ]; then
    PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"
    export PS1="$venv_name$BOLDGREEN\u@\h$DEFAULT: $YELLOW\w $CYAN\$git_branch$RED\$git_dirty$DEFAULT\n\$ "
    return
fi

# Default Git enabled prompt {{{1
PROMPT_COMMAND="_prompt_command; $PROMPT_COMMAND"

_prompt_command() {
    curr_exit="$?"
    cmd_err_glyph='✘'
    cmd_ok_glyph='✔'
    gitpr="$(gitpr -s 2>/dev/null)"
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
