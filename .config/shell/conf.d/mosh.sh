#!/bin/sh

MOSH_CONNECTION=0
pid=0

if [ -n "$TMUX" ]; then
    tmux_current_session="$(tmux display-message -p '#S')"
    pid="$(tmux list-clients -t "$tmux_current_session" -F '#{client_pid}')"
else
    pid=$$
fi
if pstree -ps "$pid" | grep -q 'mosh-server'; then
    MOSH_CONNECTION=1
fi
export MOSH_CONNECTION
