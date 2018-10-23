# Defined in - @ line 2
function vi_mode --description 'Toggle vi-mode keybindings'
	set -gx fish_old_key_bindings $fish_key_bindings
    if test $fish_old_key_bindings != fish_vi_key_bindings
        fish_user_vi_key_bindings
        set_color yellow
        echo "vi mode activated!"
        set_color normal
    else
        # Already in vi mode; reset to previous
        fish_default_key_bindings
        set_color yellow
        echo "vi mode deactivated!"
        set_color normal
    end
end
