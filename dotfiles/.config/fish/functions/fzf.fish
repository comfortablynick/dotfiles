# Defined in /tmp/fish.QEO9d3/fzf.fish @ line 2
function fzf --description 'call fzf binary'
	if test -n "$TMUX" && type -q fzf-tmux
        fzf-tmux
    else if type -q fzf
        fzf
    else
        echo "fzf binary not found!"
        return 1
    end
end
