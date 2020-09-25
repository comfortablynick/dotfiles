set -Ux MOSH_CONNECTION 0
set -l tmux_current_session
set -l pid
if test -n "$TMUX"
    set tmux_current_session (tmux display-message -p '#S')
    set pid (tmux list-clients -t "$tmux_current_session" -F '#{client_pid}')
else
    set pid "$fish_pid"
end
if test (pstree -ps "$pid" | string match -r 'mosh-server')
    set MOSH_CONNECTION 1
end
