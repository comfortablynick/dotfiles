#!/usr/bin/env bash

# Return if not Linux
[ ${OS_NAME} != "Linux" ] && return;


# Source colors from file
if [ -x /usr/bin/dircolors ]; then
   [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Commenting this line out will revert to standard PS1 prompt
# export POWERLINE_ROOT="/usr/local/lib/python3.7/site-packages/powerline"

# export VCPROMPT_FORMAT="%n %b %r %p %u %m"

# Try to load nvm on demand
# lnvm() {
#     # Load nvm and nvm bash completions
#     [ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
#     [ -s "${NVM_DIR}/bash_completion" ] && \. "${NVM_DIR}/bash_completion"
# }
