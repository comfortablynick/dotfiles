# Defined in /tmp/fish.PVZMz4/tm.fish @ line 2
function tm --description 'attach to existing tmux or create new one' --argument session_name
	test -n "$session_name"; or set -l session_name 'def'
    if type -q tmux
        if test -z "$TMUX"
            tmux new-session -A -s "$session_name"; and kill $fish_pid
        else
            tmux ls
            return 0
        end
    else
        echo "TMUX not found!"
        return 1
    end
    # Something went wrong
    echo "Error attaching/creating tmux session '$session_name'."
    return 1
end
