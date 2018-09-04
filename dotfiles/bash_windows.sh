#!/usr/bin/env bash

# Return if not Windows
[ ${OS_NAME} != "Windows" ] && return;

# Debug
[ ${DEBUG} == true ] && echo "Using .bash_windows";

# Git
GIT_DIR="${HOME}/Git"
alias gpython='cd ${GIT_DIR}/python'
alias ggas='cd ${GIT_DIR}/google-apps-script/sheets'
alias gcp='cd ${GIT_DIR}/google-apps-script/sheets/convention-personnel'
alias gcpr='cd ${GIT_DIR}/google-apps-script/sheets/convention-personnel-reports'
alias gdspw='cd ${GIT_DIR}/google-apps-script/sheets/dspw'
alias gfst='cd ${GIT_DIR}/google-apps-script/sheets/fs-time'

# Python Venv 
VENV_DIR="${HOME}/.pyenv/Scripts/activate"
alias pyenv="source ${VENV_DIR}"

# Activate venv by default
source ${VENV_DIR}

