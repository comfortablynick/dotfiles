function forget --description 'Forget item from commandline history'
    set -l cmd (commandline | string collect)
    if test -z $cmd
        return
    end
    set -l prompt_color $fish_color_command
    set -l command_color $fish_color_quote
    set -l prompt (set_color $prompt_color; echo -n " Do you want to forget"; set_color normal)
    set -a prompt (set_color $command_color; echo -n "'$cmd'"; set_color normal; set_color $prompt_color; echo -n "? [Y/n]> "; set_color normal)
    read -p 'echo $prompt' continue
    switch (string lower $continue)
        case n no
            commandline -f repaint
            return
        case y yes ''
            history delete --exact --case-sensitive -- $cmd
            commandline ""
            commandline -f repaint
    end
end
