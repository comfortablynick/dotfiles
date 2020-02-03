# This should be overwritten later
if [ -d "$HOME/go/bin" ]; then
    PATH="$HOME/go/bin:$PATH"
fi

# get jump hook
eval "$(jump shell "$CURRENT_SHELL")"
