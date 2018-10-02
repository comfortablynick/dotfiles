#!/usr/bin/env bash
# GIT-AWARE PROMPT 

find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    git_branch="($branch)"
  else
    git_branch=""
  fi
}

find_git_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty='*'
  else
    git_dirty=''
  fi
}


# COLORS
DEFAULT="\[\033[0;00m\]"
BOLDGREEN="\[\033[01;32m\]"
BOLDBLUE="\[\033[01;34m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
RED="\[\033[0;31m\]"
CYAN="\[\033[0;36m\]"

# Default Git enabled prompt with dirty state
PROMPT_COMMAND="find_git_branch; find_git_dirty; $PROMPT_COMMAND"
export PS1="$BOLDGREEN\u@\h$DEFAULT: $YELLOW\w $CYAN\$git_branch$RED\$git_dirty$DEFAULT\n\$ "

# Powerline
if [ "$POWERLINE_ROOT" != "" ]; then
    if [ -f "${POWERLINE_ROOT}/bindings/bash/powerline.sh" ]; then
        # if [ command -v powerline-daemon 2>/dev/null ]; then
        powerline-daemon -q
        POWERLINE_BASH_CONTINUATION=1
        POWERLINE_BASH_SELECT=1
        . "${POWERLINE_ROOT}/bindings/bash/powerline.sh"
    fi
fi
