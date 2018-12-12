# Start tmux session for interactive shells
if status is-interactive
    and test -z "$TMUX"
    and not set -q no_tmux_login

    set -l session_name

    if test -n "$SSH_CONNECTION"
        set session_name 'ios'
    else
        set session_name 'def'
    end
       exec tmux new-session -A -s "$session_name"
end
