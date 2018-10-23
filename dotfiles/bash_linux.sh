#!/usr/bin/env bash

# Return if not Linux
[[ ${OS_NAME} != "Linux" ]] && return;


# WSL (Windows Subsystem for Linux) Fixes
if [[ -f /proc/version ]] && grep -q "Microsoft" /proc/version; then

  # Fix umask value if WSL didn't set it properly.
  # https://github.com/Microsoft/WSL/issues/352
  [[ "$(umask)" == "000" ]] && umask 022


fi

# Source colors from file
if [[ -x /usr/bin/dircolors ]]; then
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
alias gdspwe='cd ~/git/google-apps-script/sheets/dspw-email'


# PYTHON ------------------------------------------------------
# Virtual Env
export VENV_DIR="${HOME}/.env"
export NVIM_PY2_DIR="${VENV_DIR}/nvim2"
export NVIM_PY3_DIR="${VENV_DIR}/nvim3"
alias denv='source ${VENV_DIR}/dev/bin/activate'

if [[ ! -n "$VIRTUAL_ENV" ]]; then
  source "${VENV_DIR}/dev/bin/activate" # Activate by default
fi

export POWERLINE_ROOT="/usr/local/lib/python3.7/site-packages/powerline"

# SYSTEM ------------------------------------------------------
export NVM_DIR="$HOME/.nvm"

# Try to load nvm on demand
lnvm() {
    # Load nvm and nvm bash completions
    [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
    [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"
}
