# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.bqD3di/tmux:kill_unattached.fish @ line 2
function tmux:kill_unattached --description 'kills all sessions other than currently attached one'
	set -l sessions (tmux ls)
    if test -z "$sessions"
        echo "No TMUX sessions!"
        return 1
    end
    # Execute kill command in awk
    tmux ls | awk '$1 gsub(":", "") {if (!/attached/) system("tmux kill-session -t " $1)}'
end
