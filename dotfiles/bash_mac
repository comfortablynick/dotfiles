#!/usr/bin/env bash
# Return if not Mac
[ ${OS_NAME} != "Mac" ] && return;

# Debug
[ ${DEBUG} == true ] && echo "Using .bash_mac";

# Load colors config file
[ -f ${HOME}/.dircolors ] && eval $(gdircolors ${HOME}/.dircolors);

# Load Git bash
[ -f ${HOME}/.git-bash-for-mac.sh ] && source ${HOME}/.git-bash-for-mac.sh;

# Git
alias gpython='cd ~/git/python'
alias ggas='cd ~/git/google-apps-script/sheets'
alias gcp='cd ~/git/google-apps-script/sheets/convention-personnel'
alias gcpr='cd ~/git/google-apps-script/sheets/convention-personnel-reports'
alias gdspw='cd ~/git/google-apps-script/sheets/dspw'
alias gdot='cd ~/dotfiles'

# Python Venv
alias py='source ~/env/bin/activate'

# Setting PATH for Python 3.6
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"

# Setting PATH for Python 3.7
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"

# Setting PATH for coreutils
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

# enable programmable completion features 
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
