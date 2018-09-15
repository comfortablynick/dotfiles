#!/usr/bin/env bash
# Return if not Mac
[ ${OS_NAME} != "Mac" ] && return;

# Enable color support of ls and read color conifg file
[ -f ${HOME}/.dircolors ] && eval $(gdircolors ${HOME}/.dircolors);

# Git
alias gpython='cd ~/git/python'
alias ggas='cd ~/git/google-apps-script/sheets'
alias gcp='cd ~/git/google-apps-script/sheets/convention-personnel'
alias gcpr='cd ~/git/google-apps-script/sheets/convention-personnel-reports'
alias gdspw='cd ~/git/google-apps-script/sheets/dspw'
alias gdot='cd ~/dotfiles'
alias gfst='cd ~/git/google-apps-script/sheets/fs-time'

# Setting PATH for Python 3.6
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"

# Setting PATH for Python 3.7
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"

# Setting PATH for coreutils
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

# Python Venv
export WORKON_HOME=${HOME}/.pyenv
export VIRTUALENVWRAPPER_PYTHON="$(which python3)"
export VIRTUALENVWRAPPER_SCRIPT=/Library/Frameworks/Python.framework/Versions/3.7/bin/virtualenvwrapper.sh
source /Library/Frameworks/Python.framework/Versions/3.7/bin/virtualenvwrapper.sh
workon dev # Enter default venv

# enable programmable completion features 
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#--------------------------------------------------------------------------
# MAC FUNCTIONS
#--------------------------------------------------------------------------

# Show/hide hidden files
function togglehidden() {
    ISHIDDEN=$(defaults read com.apple.finder AppleShowAllFiles)
    if [ $ISHIDDEN == TRUE ]; then
        defaults write com.apple.finder AppleShowAllFiles FALSE
    else
        defaults write com.apple.finder AppleShowAllFiles TRUE
    fi
    killall Finder
}
