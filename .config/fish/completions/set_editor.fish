# Completion for set_editor
# Set EDITOR/VISUAL env vars to vim/nvim

complete -c set_editor -f -s h -l help      -d 'show help text and exit'
complete -c set_editor -f -s t -l toggle    -d 'toggle editor between vim/nvim'
complete -c set_editor -f -s v -l vim       -d 'set editor to vim'
complete -c set_editor -f -s n -l nvim      -d 'set editor to neovim'
