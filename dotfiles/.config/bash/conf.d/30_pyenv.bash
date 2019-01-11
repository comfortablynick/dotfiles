# Source pyenv/venv if available
if [ -d "$HOME/.pyenv" ]; then
    command pyenv rehash 2>/dev/null
    # eval "$(pyenv init -)"
    # eval "$(pyenv virtualenv-init -)"
fi
