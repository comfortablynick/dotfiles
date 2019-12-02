# Setup fzf
# ---------

if [[ ! -x $HOME/.fzf/bin/fzf ]] && ! (( $+commands[fzf] )); then
    # Install FZF
    if [[ ! -d $HOME/.fzf ]]; then
        echo "fzf dir not found. Cloning fzf and installing..."
        command git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    fi
    echo "Installing fzf..."
    ~/.fzf/install --bin --no-key-bindings --no-update-rc
    export -U PATH=$HOME/.fzf/bin${PATH:+:$PATH}
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source $HOME/.fzf/shell/completion.zsh 2>/dev/null

# Key bindings
# ------------
source $HOME/.fzf/shell/key-bindings.zsh 2>/dev/null
