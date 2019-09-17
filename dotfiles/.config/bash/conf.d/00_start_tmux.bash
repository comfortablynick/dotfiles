# TMUX Initialization (called from .bashrc)
# Abort if
#       - not interactive
#       - already in tmux
#       - 'no tmux' file exists in home dir for this shell
#       - in vscode remote session
#       - `tmux` command not present
export PATH="$HOME/.local/bin:$PATH"
{
    [[ $- != *i* ]] ||
        [[ -n $TMUX ]] ||
        [[ -f "$HOME/.no_bash_tmux_login" ]] ||
        [[ $TERM_PROGRAM == "vscode" ]] ||
            [[ -z $(command -v tmux) ]]
} && return

if [[ ! -f $HOME/.no_bash_tmux_next_login ]]; then
    export SUB='|'
    export RSUB='|'
    session_name=""
    echo "Starting tmux..."
    [[ -n $SSH_CONNECTION ]] && session_name="ios" || session_name="def"
    exec tmux -2 new-session -A -s "$session_name"
else
    rm "$HOME/.no_bash_tmux_next_login"
    echo -e "$(echo -ne '\033[1;33m')"
    echo "Note: 'no_tmux_next_login' flag was set for this login."
    echo "TMUX will be used on next login unless flag is reset."
    echo -e "$(echo -ne '\033[0m')"
fi
