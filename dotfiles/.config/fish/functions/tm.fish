# Defined in /tmp/fish.2w9SYJ/tm.fish @ line 2
function tm --description 'attach to existing tmux or create new one' --argument session_name
	test -n "$session_name" || set -l session_name 'def'
    tmux_attach $session_name;
    or tmux_new $session_name;
    or echo "Cannot attach/create tmux session '$session_name'."
end
