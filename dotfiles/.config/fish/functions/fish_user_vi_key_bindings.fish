# Defined in - @ line 2
function fish_user_vi_key_bindings --description 'Custom vi-mode bindings'
	fish_vi_key_bindings
    bind -M insert -m default kj backward-char force-repaint
end
