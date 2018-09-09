#!/usr/bin/env bash
# Return if not Mac
[ ${OS_NAME} != "Mac" ] && return;

# Enable color support of ls and read color conifg file
[ -f ${HOME}/.dircolors ] && eval $(gdircolors ${HOME}/.dircolors);

# alias ls='ls --color=auto'
# alias grep='grep --color=auto'
# alias fgrep='fgrep --color=auto'
# alias egrep='egrep --color=auto'

# Load Git bash
# [ -f ${HOME}/.git-bash-for-mac.sh ] && source ${HOME}/.git-bash-for-mac.sh;

# Git
alias gpython='cd ~/git/python'
alias ggas='cd ~/git/google-apps-script/sheets'
alias gcp='cd ~/git/google-apps-script/sheets/convention-personnel'
alias gcpr='cd ~/git/google-apps-script/sheets/convention-personnel-reports'
alias gdspw='cd ~/git/google-apps-script/sheets/dspw'
alias gdot='cd ~/dotfiles'
alias gfst='cd ~/git/google-apps-script/sheets/fs-time'

# Python Venv
export VENV_DIR="${HOME}/env/bin/activate"
alias py="source ${VENV_DIR}"

# Activate venv by default
source $VENV_DIR

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
