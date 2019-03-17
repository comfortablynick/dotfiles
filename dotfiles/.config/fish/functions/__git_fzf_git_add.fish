# Defined in /tmp/fish.RL79we/__git_fzf_git_add.fish @ line 2
function __git_fzf_git_add
	set -l result

    __git_fzf_git_status | \
        while read -l r
        set -a result $r
    end
    test -n "$result"
    and git add $result

    commandline -f repaint
end
