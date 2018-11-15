# Defined in /tmp/fish.u5z9Xc/tmux_attach.fish @ line 2
function tmux_attach --description 'attach to existing tmux session' --argument session_name
	test -n "$session_name" || set -l session_name 'def'
	tmux has-session -t $session_name > /dev/null 2>&1
and tmux attach-session -t $session_name
end
