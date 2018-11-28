# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.kum8Ad/__fzf_autojump.fish @ line 2
function __fzf_autojump
	if test -n "$argv"
        cd (autojump $argv)
        return
    end
    cd (autojump -s | sort -n --reverse | awk '/^[0-9\.]+:\t\// { FS = ":\t"; print $2 }' | eval (__fzfcmd) --reverse --inline-info)
end
