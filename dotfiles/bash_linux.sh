#!/usr/bin/env bash
# Return if not Linux
[ ${OS_NAME} != "Linux" ] && return;

# Source colors from file 
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# ALIASES -----------------------------------------------------

# Git
alias gpython='cd ~/git/python'
alias ggas='cd ~/git/google-apps-script/sheets'
alias gfst='cd ~/git/google-apps-script/sheets/fs-time'
alias gcp='cd ~/git/google-apps-script/sheets/convention-personnel'
alias gcpr='cd ~/git/google-apps-script/sheets/convention-personnel-reports'
alias gdspw='cd ~/git/google-apps-script/sheets/dspw'
alias gdot='cd ~/dotfiles'

# PYTHON ------------------------------------------------------
# Main Venv
export VENV_DIR="${HOME}/.pyenv/bin/activate"
if [ -f "${VENV_DIR}" ]; then
    alias py="source ${VENV_DIR}"
    # Activate the venv by default
    source ${VENV_DIR}
fi

# Path -- add directories to default path
export PYTHONPATH="${PYTHONPATH}:${HOME}/git/python/lib"

# SYSTEM ------------------------------------------------------

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

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
