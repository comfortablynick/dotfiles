# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.2G97xm/tm.fish @ line 2
function tm --description 'attach to existing tmux or create new one' --argument session_name
	test -n "$session_name" || set -l session_name 'def'
    if type -q tmux
        if test -z "$TMUX"
            tmux new-session -A -s "$session_name";
            and kill $fish_pid;
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
