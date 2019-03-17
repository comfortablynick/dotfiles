# Defined in /tmp/fish.JzXZuX/__git_fzf_git_status.fish @ line 2
function __git_fzf_git_status
	__git_fzf_is_in_git_repo
    or return
    git -c color.status=always status --short | \
        fzf-tmux -m --ansi --preview 'git diff --color=always HEAD -- {-1} | head -500' | \
        cut -c4- | \
        sed 's/.* -> //'
    commandline -f repaint
end
