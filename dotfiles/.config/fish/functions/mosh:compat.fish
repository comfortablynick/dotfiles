# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.ubbDUD/mosh:compat.fish @ line 1
function mosh:compat --description 'enable compatibility features for mosh connections'
	if test $VIM_SSH_COMPAT -eq 0
        set VIM_SSH_COMPAT 1
    end
end
