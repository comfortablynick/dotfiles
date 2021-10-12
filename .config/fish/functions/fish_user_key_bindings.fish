function fish_user_key_bindings
    fish_vi_key_bindings

    # Normal bindings
    bind \ce 'edit -f sweep -- -p $EDITOR'
    bind _ beginning-of-line
    bind \cb forget

    # Insert mode
    bind -M insert \cf forward-char # accept suggestion
    bind -M insert kj 'if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint-mode; end'
    bind -M insert \ce 'edit -f sweep -- -p $EDITOR'
    bind -M insert \cb forget

    # Fzf additional bindings
    bind \ct _fzf_search_directory
    bind -M insert \ct _fzf_search_directory
end
