# Defined in /tmp/fish.YMZdcA/__git_fzf_git_unstage.fish @ line 2
function __git_fzf_git_unstage --description 'Remove staging of a file after `git add`'
	__git_fzf_is_in_git_repo
    or return

	set -l result

    #
    git -c color.status=always status --short | \
        sk-tmux -m --ansi --preview 'git diff --color=always HEAD -- {-1} | head -500' | \
        # cut -c4- | \
        sed 's/.* -> //' | \
        while read -l r
        set -a result $r
    end

    test -n "$result"
    and git reset HEAD $result

    commandline -f repaint
end
