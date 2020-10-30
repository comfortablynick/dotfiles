# Defined in /tmp/fish.NcJ7lJ/fish_user_key_bindings.fish @ line 2
function fish_user_key_bindings
    fish_vi_key_bindings

    # Normal bindings
    bind \ce 'edit -f sweep -- -p $EDITOR'
    bind _ beginning-of-line

    # Insert mode
    bind -M insert \cf forward-char # accept suggestion
    bind -M insert kj 'if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char repaint-mode; end'
    bind -M insert \ce 'edit -f sweep -- -p $EDITOR'

    # fzf
    bind \cg __fzf_search_current_dir
    bind \ct fzf_open_file
    bind \cr __fzf_search_history
    bind \cv __fzf_search_shell_variables
    bind \e\cl __fzf_search_git_log
    bind \e\cs __fzf_search_git_status

    bind -M insert \cg __fzf_search_current_dir
    bind -M insert \ct fzf_open_file
    bind -M insert \cr __fzf_search_history
    bind -M insert \cv __fzf_search_shell_variables
    bind -M insert \e\cl __fzf_search_git_log
    bind -M insert \e\cs __fzf_search_git_status
end
