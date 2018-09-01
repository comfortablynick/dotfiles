#!/usr/bin/env bash

# Return if not Windows
[ ${OS_NAME} != "Windows" ] && return;

# Debug
[ ${DEBUG} == true ] && echo "Using .bash_windows";

# Git
alias gpython='cd ~/Git/python'
alias ggas='cd ~/Git/google-apps-script/sheets'
alias gcp='cd ~/Git/google-apps-script/sheets/convention-personnel'
alias gcpr='cd ~/Git/google-apps-script/sheets/convention-personnel-reports'
alias gdspw='cd ~/Git/google-apps-script/sheets/dspw'

# Python Venv ("py") already used in Windows"
alias pyenv='source ~/.pyenv/Scripts/activate'
