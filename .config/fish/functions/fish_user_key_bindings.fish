# Defined in /tmp/fish.7GuxkB/fish_user_key_bindings.fish @ line 2
function fish_user_key_bindings
    fish_vi_key_bindings

    # Normal bindings
    bind \cE edit
    bind \cT fzf_open_file

    # Insert mode
    bind -M insert -m default kj force-repaint
    bind -M insert \cE edit
    bind -M insert \cT fzf_open_file
end
