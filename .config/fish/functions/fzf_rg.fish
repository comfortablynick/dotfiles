function fzf_rg --description 'Search files using rg + fzf and open in nvim'
    set -l initial_query (string escape "$argv")
    set -l rg_cmd "rg --vimgrep --color=always --smart-case"
    set -l change_key ctrl-f

    FZF_DEFAULT_COMMAND="$rg_cmd $initial_query" fzf-tmux -p 60%,80% --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --disabled --query "$argv" \
        --bind "change:reload:sleep 0.1; $rg_cmd {q} || true" \
        --bind "$change_key:unbind(change,$change_key)+change-prompt(2. fzf> )+enable-search+clear-query" \
        --header "Press $change_key to switch to fzf" \
        --prompt '1. rg> ' \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' | read -l result
    set -l files (string split : $result)

    if test -z $files[1]
        commandline -f repaint
        return
    end

    set -l cursor (string escape "norm!$files[2]G$files[3]|")
    # Start commandline with space so that we can re-use command right away
    # but it will not persist in history
    commandline -r " "
    commandline -it -- "nvim $files[1] +$cursor"
    commandline -f execute
end
