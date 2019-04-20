#!/usr/bin/env bash
# Return if not Mac
[ ${OS_NAME} != "Mac" ] && return;

# Enable color support of ls and read color conifg file
[ -f ${HOME}/.dircolors ] && eval $(gdircolors ${HOME}/.dircolors);

# Git
# alias gpython='cd ~/git/python'
# alias ggas='cd ~/git/google-apps-script/sheets'
# alias gcp='cd ~/git/google-apps-script/sheets/convention-personnel'
# alias gcpr='cd ~/git/google-apps-script/sheets/convention-personnel-reports'
# alias gdspw='cd ~/git/google-apps-script/sheets/dspw'
# alias gdspwe='cd ~/git/google-apps-script/sheets/dspw-email'
# alias gfst='cd ~/git/google-apps-script/sheets/fs-time'

# Setting PATH for Python 3.6
# PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"

# Setting PATH for Python 3.7
# PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"

# Setting PATH for coreutils
PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"

# Language Defaults
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Python Venv
# export VENV_DIR="${HOME}/.env"
# export NVIM_PY2_DIR="${VENV_DIR}/nvim2"
# export NVIM_PY3_DIR="${VENV_DIR}/nvim3"

# alias denv="source ${VENV_DIR}/dev/bin/activate"
# . ${VENV_DIR}/dev/bin/activate

# enable programmable completion features 
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Powerline
# export POWERLINE_ROOT="/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/powerline"

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
