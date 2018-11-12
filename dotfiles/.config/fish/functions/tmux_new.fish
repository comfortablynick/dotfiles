# Defined in /tmp/fish.R2rBnl/tmux_new.fish @ line 2
function tmux_new --description 'create new tmux session' --argument session_name
	test -n "$session_name" || set -l session_name 'default'
    echo "Creating tmux session '$session_name'"
	tmux new-session -s $session_name;
    and kill %self
end
