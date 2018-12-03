# Defined in /tmp/fish.45qBb8/tmux:session_name.fish @ line 2
function tmux:session_name --description 'return active session name, if any'
	if test -n "$TMUX_PANE"
        echo (tmux list-panes -t "$TMUX_PANE" -F '#S' | head -n1)
    end
end
