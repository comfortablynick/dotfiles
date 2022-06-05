function fzf --description 'Use fzf-tmux in place of fzf'
    if command -q fzf-tmux
        # fzf-tmux already handles if we aren't in a tmux session
        fzf-tmux $argv
    else
        command fzf $argv
    end
end
