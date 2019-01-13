# Source pyenv/venv if available
if [ -d "$HOME/.pyenv" ]; then
    command pyenv rehash 2>/dev/null
    # eval "$("$HOME/.pyenv/bin/pyenv" init -)"
    # eval "$("$HOME/.pyenv/bin/pyenv" virtualenv-init -)"
fi
