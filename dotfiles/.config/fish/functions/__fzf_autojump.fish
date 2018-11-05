# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.3ESt8A/__fzf_autojump.fish @ line 2
function __fzf_autojump
	if test -n "$argv"
        cd (autojump $argv)
        return
    end
    cd (autojump -s | awk '/^[0-9\.]+:\t\// { FS = ":\t"; print $2 }' | fzf --height 40% --reverse --inline-info)
end
