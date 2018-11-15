# Defined in /tmp/fish.l8uIzC/tm.fish @ line 2
function tm --description 'attach to existing tmux or create new one' --argument session_name
	test -n "$session_name" || set -l session_name 'def'
    begin
        tmux_attach $session_name;
        or tmux_new $session_name;
        and kill $fish_pid
    end;
    echo "Cannot attach/create tmux session '$session_name'."
end
