# Source pyenv/venv if available
if [ -d "$HOME/.pyenv" ]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
elif [ -n "$def_venv" ]; then
    . "$dev_venv/bin/activate"
fi
