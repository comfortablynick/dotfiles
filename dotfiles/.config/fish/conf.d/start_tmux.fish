# Start tmux session for interactive shells
if status is-interactive
    and test -z "$TMUX"
    and not set -q no_tmux_login

    if not set -q no_tmux_next_login
        test -n "$SSH_CONNECTION"
        and set -l session_name 'ios'
        or set -l session_name 'def'

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
