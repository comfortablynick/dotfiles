#!/usr/bin/env bash
# Add bash aliases here for all platforms

# Debug
[ ${DEBUG} == true ] && echo "Using .bash_aliases";

# Autocorrect
alias exif='exit'

# ls
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# file handling
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias h='cd ~/'
alias r='cd /'
alias q='exit'

# Git
alias gpl='git pull'
alias gph='git push'
alias gdiff='git diff'
alias gst='git status -s'

# dotdrop
alias gdot='cd ~/dotfiles'
alias dotdrop='~/dotfiles/dotdrop.sh'
alias dotgit='git -C ~/dotfiles'
alias dotsync="dotgit pull && dotgit add -A && dotgit commit && dotgit push; dotdrop install"
