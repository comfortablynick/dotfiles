# Defined in /tmp/fish.ZHRpXD/__fzf_autojump.fish @ line 2
function __fzf_autojump --description 'fzf search if no args'
	if test -n "$argv"
        cd (autojump $argv)
        return
    end
    cd (autojump -s | sort -n --reverse | awk '/^[0-9\.]+:\t\// { FS = ":\t"; print $2 }' | eval (__fzfcmd) --reverse --inline-info)
end
