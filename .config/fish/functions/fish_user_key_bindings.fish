function fish_user_key_bindings
    fish_vi_key_bindings

    # Normal bindings
    bind \ce edit
    bind \cz fzf_rg
    bind _ beginning-of-line
    bind \cb forget
    bind \en 'fish_commandline_prepend nvim; commandline -f execute'

    # Insert mode
    bind -M insert \cf forward-char # accept suggestion
    bind -M insert kj 'if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint-mode; end'
    bind -M insert \ce edit
    bind -M insert \cz fzf_rg
    bind -M insert \cb forget
    bind -M insert \en 'fish_commandline_prepend nvim; commandline -f execute'

    # Fzf additional bindings
    bind \ct _fzf_search_directory
    bind -M insert \ct _fzf_search_directory
end
