#!/usr/bin/env bash
# Return if not Linux
[ ${OS_NAME} != "Linux" ] && return;

# Debug
[ ${DEBUG} == true ] && echo "Using .bash_linux";

# PROMPT ------------------------------------------
source /usr/lib/git-core/git-sh-prompt

# COLORS
DEFAULT="\[\033[0;00m\]"
LIGHTGREEN="\[\033[01;32m\]"
LIGHTBLUE="\[\033[01;34m\]"

# Colors from git prompt (Mac)
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
CYAN="\[\033[0;36m\]"

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}${LIGHTGREEN}\u@\h${DEFAULT}:${YELLOW} \w${CYAN}"'$(__git_ps1 " (%s)")'"${DEFAULT}\n\$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ALIASES -----------------------------------------------------

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Git
alias gpython='cd ~/git/python'
alias ggas='cd ~/git/google-apps-script/sheets'
alias gcp='cd ~/git/google-apps-script/sheets/convention-personnel'
alias gcpr='cd ~/git/google-apps-script/sheets/convention-personnel-reports'
alias gdspw='cd ~/git/google-apps-script/sheets/dspw'
alias gdot='cd ~/dotfiles'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# PYTHON
export PYTHONPATH="${PYTHONPATH}:/home/pi/git/python/lib"
alias config='/usr/bin/git --git-dir=/home/pi/.cfg/ --work-tree=/home/pi'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
