# TMUX Initialization
# Abort if
#       - not interactive
#       - already in tmux
#       - 'no tmux' file exists in home dir for this shell
#       - in vscode remote session
#       - `tmux` command not present
export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib"
{
    [ -n "$TMUX" ] ||
        [ -f "$HOME/.no_tmux_login" ] ||
        [ "$TERM_PROGRAM" = "vscode" ] ||
        [ -z "$(command -v tmux)" ]
} && return
if [ ! -f "$HOME/.no_tmux_next_login" ]; then
    export SUB='|'
    export RSUB='|'
    echo "Starting tmux..."
    exec tmux -2 new-session -A -s "def"
else
    rm "$HOME/.no_tmux_next_login"
    printf '\033[1;33m%s\033[0m\n' \
        'Note: "no_tmux_next_login" flag was set for this login.' \
        'TMUX will be used on next login unless flag is reset.'
fi
