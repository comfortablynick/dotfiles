# Return if already in tmux or if special var is set
[ -n "$TMUX" -o -f "$HOME/.no_zsh_tmux_login" ] && return

if [ ! -f "$HOME/.no_zsh_tmux_next_login" ]; then
    # Start tmux
    session_name=""
    echo "Starting tmux..."
    [ -n "$SSH_CONNECTION" ] && session_name="ios" || session_name="def"
    exec tmux -2 new-session -A -s "$session_name"
else
    rm "$HOME/.no_zsh_tmux_next_login"
    echo -e $(echo -ne '\033[1;33m')
    echo "Note: 'no_zsh_tmux_next_login' flag was set for this login."
    echo "TMUX will be used on next zsh login unless flag is reset."
    echo -e $(echo -ne '\033[0m')
fi
