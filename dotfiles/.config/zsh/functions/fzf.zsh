# Setup fzf
# ---------
if [[ ! "$PATH" == */c/Users/nmurphy/.fzf/bin* ]]; then
  export PATH="$PATH:/c/Users/nmurphy/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/c/Users/nmurphy/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/c/Users/nmurphy/.fzf/shell/key-bindings.zsh"

