# Setup fzf
# ---------
if [ -z "$(command -v fzf)" ]; then
    # Install FZF
    if [ ! -d "$HOME/.fzf" ]; then
        echo "fzf dir not found. Cloning fzf and installing..."
        command git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi
    echo "Installing fzf..."
    ~/.fzf/install --bin --no-key-bindings --no-update-rc
fi

if [[ ! "$PATH" == *"$HOME"/.fzf/bin* ]]; then
  export PATH="$PATH:$HOME/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && . "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
. "$HOME/.fzf/shell/key-bindings.bash"
