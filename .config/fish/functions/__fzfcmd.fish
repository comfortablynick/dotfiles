function __fzfcmd
    test -n "$FZF_TMUX"; or set FZF_TMUX 0
    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    if [ -n "$FZF_TMUX_OPTS" ]
      echo "fzf-tmux $FZF_TMUX_OPTS -- "
    else if [ $FZF_TMUX -eq 1 ]
      echo "fzf-tmux -d$FZF_TMUX_HEIGHT -- "
    else
      echo "fzf"
    end
  
end
