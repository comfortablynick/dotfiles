# Defined in /tmp/fish.U30jpE/__git_fzf_git_unstage.fish @ line 2
function __git_fzf_git_unstage --description 'Remove staging of a file after `git add`'
	set -l result

    __git_fzf_git_status | \
        while read -l r
        set -a result $r
    end
    test -n "$result"
    and git reset HEAD $result

    commandline -f repaint
end
