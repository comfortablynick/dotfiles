# Defined in /tmp/fish.3WLM3w/__git_fzf_git_add.fish @ line 2
function __git_fzf_git_add
	__git_fzf_is_in_git_repo
    or return

	set -l result

    # Only show unstaged changes
    # git ls-files --exclude-standard -m -o | \
    git -c color.status=always status -s | \
        sk-tmux -m --ansi --preview 'git diff --color=always HEAD -- {-1} | head -500' | \
        cut -c4- | \
        sed 's/.* -> //' | \
        while read -l r
        set -a result $r
    end

    test -n "$result"
    and git add $result

    commandline -f repaint
end
