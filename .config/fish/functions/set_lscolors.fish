# Defined in /tmp/fish.FMaWES/set_lscolors.fish @ line 2
function set_lscolors --description 'Set LS_COLORS variable'
	if not set -q LS_COLORS
        set -l dir_cmd
        if type -qf gdircolors
            set dir_cmd gdircolors
        else if type -qf dircolors
            set dir_cmd dircolors
        end
        set -l colorfile
        for file in "$HOME/.dircolors" "$HOME/dircolors" "/etc/DIR_COLORS"
            if test -f $file
                set colorfile $file
                break
            end
        end
        # eval (eval "$dir_cmd -c $colorfile" | sed 's/setenv LS_COLORS/set -gx LS_COLORS/')
    end
end
