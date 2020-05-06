#!/bin/sh

if [ -z "$(command -v fzf)" ] || [ ! -d "$HOME/.fzf" ]; then
    return
fi

shell="$(basename "$SHELL")"

if [ "$shell" = "zsh" ]; then
    . $HOME/.fzf/shell/completion.zsh 2>/dev/null
    . $HOME/.fzf/shell/key-bindings.zsh 2>/dev/null
fi

if [ "$shell" = "bash" ]; then
    . $HOME/.fzf/shell/completion.bash 2>/dev/null
    . $HOME/.fzf/shell/key-bindings.bash 2>/dev/null
fi
