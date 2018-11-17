# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.KvcWUj/tmux:kill_all.fish @ line 2
function tmux:kill_all --description 'kill all tmux sessions'
	set -l sessions (tmux ls)
    if test -z "$sessions"
        echo "No TMUX sessions!"
        return 1
    end
    # Execute kill command in awk
    tmux ls | awk '$1 gsub(":", "") {system("tmux kill-session -t " $1)}'
end
