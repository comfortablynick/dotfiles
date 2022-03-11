function fish_user_key_bindings
    fish_vi_key_bindings

    # Normal bindings
    bind \ce edit
    bind \cs fzf_rg
    bind \cw 'edit -f sweep -- -p $EDITOR --theme dark'
    bind _ beginning-of-line
    bind \cb forget
    bind \en 'fish_commandline_prepend nvim; commandline -f execute'

    # Insert mode
    bind -M insert \cf forward-char # accept suggestion
    bind -M insert kj 'if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint-mode; end'
    bind -M insert \ce edit
    bind -M insert \cs fzf_rg
    bind -M insert \cw 'edit -f sweep -- -p $EDITOR --theme dark'
    bind -M insert \cb forget
    bind -M insert \en 'fish_commandline_prepend nvim; commandline -f execute'

    # Fzf additional bindings
    bind \ct _fzf_search_directory
    bind -M insert \ct _fzf_search_directory
end
