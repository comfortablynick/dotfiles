function fish_user_key_bindings
    fish_vi_key_bindings

    # Normal bindings
    bind \ce edit
    bind \cs fzf_rg
    bind \cw 'edit -f sweep -- -p $EDITOR --theme dark'
    bind _ beginning-of-line
    bind \cb forget
    bind \en 'fish_commandline_prepend nvim; commandline -f execute'
    bind \ef thefuck-command-line

    # Insert mode
    bind -M insert \cf forward-char # accept suggestion
    bind -M insert kj 'if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint-mode; end'
    bind -M insert \ce edit
    bind -M insert \cs fzf_rg
    bind -M insert \cw 'edit -f sweep -- -p $EDITOR --theme dark'
    bind -M insert \cb forget
    bind -M insert \en 'fish_commandline_prepend nvim; commandline -f execute'
    bind -M insert \ef thefuck-command-line

    # Fzf additional bindings
    bind \ct _fzf_search_directory
    bind -M insert \ct _fzf_search_directory

    # todoist
    bind -M insert \eti fzf_todoist_item
    # bind -M insert \etp fzf_todoist_project
    # bind -M insert \etl fzf_todoist_labels
    # bind -M insert \etc fzf_todoist_close
    # bind -M insert \etd fzf_todoist_delete
    # bind -M insert \eto fzf_todoist_open
    # bind -M insert \ett fzf_todoist_date
    # bind -M insert \etq fzf_todoist_quick_add
end
