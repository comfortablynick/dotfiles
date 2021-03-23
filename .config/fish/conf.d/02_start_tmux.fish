# Start tmux session for interactive shells
if status is-interactive
    set -gx SEP ''
    set -gx SUB '|'
    set -gx RSEP ''
    set -gx RSUB '|'
    set -l no_tmux_login 0
    test -f "$HOME/.no_tmux_login"; and set no_tmux_login 1
    if type -qf tmux; and test -z "$TMUX"; and test $no_tmux_login -eq 0
        begin
            if not set -q no_tmux_next_login
                set -l session_name def
                exec tmux -2 new-session -A -s "$session_name"
            else
                set -e no_tmux_next_login
                set_color yellow
                echo "Note: 'no_tmux_next_login' flag was set for this login."
                echo "TMUX will be used on next login unless flag is reset."
                echo ""
                set_color normal
            end
        end
    end
end
