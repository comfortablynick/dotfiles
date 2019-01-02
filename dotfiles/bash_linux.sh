#!/usr/bin/env bash

# Return if not Linux
[ ${OS_NAME} != "Linux" ] && return;


# WSL (Windows Subsystem for Linux) Fixes
if [ -f /proc/version ] && grep -q "Microsoft" /proc/version; then

  # Fix umask value if WSL didn't set it properly.
  # https://github.com/Microsoft/WSL/issues/352
  [ "$(umask)" == "000" ] && umask 022


fi

# Source colors from file
if [ -x /usr/bin/dircolors ]; then
   [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# # PYTHON ------------------------------------------------------
# # Virtual Env
# export VENV_DIR="${HOME}/.env"
# export NVIM_PY2_DIR="${VENV_DIR}/nvim2"
# export NVIM_PY3_DIR="${VENV_DIR}/nvim3"
# alias denv='source ${VENV_DIR}/dev/bin/activate'

if [ -z "$VIRTUAL_ENV" ]; then
    source "${VENV_DIR}/dev/bin/activate" # Activate by default
fi

# Commenting this line out will revert to standard PS1 prompt
# export POWERLINE_ROOT="/usr/local/lib/python3.7/site-packages/powerline"

# # SCRIPTS -----------------------------------------------------
# alias list='list.py'

# # SYSTEM ------------------------------------------------------
# export NVM_DIR="$HOME/.nvm"
# export VCPROMPT_FORMAT="%n %b %r %p %u %m"

# Try to load nvm on demand
lnvm() {
    # Load nvm and nvm bash completions
    [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
    [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"
}
