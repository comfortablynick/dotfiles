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
fi

export -U PATH=$HOME/.fzf/bin${PATH:+:$PATH}

# Auto-completion
# ---------------
[[ $- == *i* ]] && source $HOME/.fzf/shell/completion.zsh 2>/dev/null

# Key bindings
# ------------
source $HOME/.fzf/shell/key-bindings.zsh 2>/dev/null

# Functions
# -----------
# cf - fuzzy cd from anywhere
# ex: cf word1 word2 ... (even part of a file name)
cf() {
    local file

    # file="$(locate -Ai -0 "$@" | grep -z -vE '~$' | fzf --read0 -0 -1)"
    # file="$(locate -Ai "$@" | rg -vP '~$' | fzy)"
    file="$(fd "$@" -t d / | fzy)"

    if [[ -n $file ]]; then
        if [[ -d $file ]]; then
            cd -- "$file"
        else
            cd -- "${file:h}"
        fi
    fi
}
