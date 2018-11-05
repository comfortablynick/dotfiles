# Defined in /tmp/fish.7U6uuD/__fzf_autojump.fish @ line 2
function __fzf_autojump
	if test -n "$argv"
        cd (autojump $argv)
        return
    end
    cd (autojump -s | sort -n --reverse | awk '/^[0-9\.]+:\t\// { FS = ":\t"; print $2 }' | fzf --height 40% --reverse --inline-info)
end
