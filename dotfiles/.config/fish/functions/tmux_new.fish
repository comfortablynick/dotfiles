# Defined in /tmp/fish.8kvFB2/tmux_new.fish @ line 2
function tmux_new --description 'create new tmux session' --argument session_name
	test -n "$session_name" || set -l session_name 'def'
    echo "Creating tmux session '$session_name'"
	tmux new-session -s $session_name;
    and kill %self
end
