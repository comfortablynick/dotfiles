function tmux_session_name --description 'return active session name, if any'
	if test -n "$TMUX_PANE"
echo (tmux list-panes -t "$TMUX_PANE" -F '#S' | head -n1)
end
end
