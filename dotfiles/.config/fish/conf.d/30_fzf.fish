# Install FZF if not already

if test -z (type -f fzf 2>/dev/null)
    if not test -d "$HOME/.fzf"
        echo "fzf dir not found. Cloning fzf and installing..."
        command git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    end
    echo "Installing fzf ..."
    ~/.fzf/install --bin --no-key-bindings --no-update-rc
end
