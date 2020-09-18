# Defined in /tmp/fish.oqetdd/fzf_open_file.fish @ line 2
function fzf_open_file --description 'List files and folders'
    set -l commandline (__fzf_parse_commandline)
    set -l dir $commandline[1]
    set -l fzf_query $commandline[2]

    # "-path \$dir'*/\\.*'" matches hidden files/folders inside $dir but not
    # $dir itself, even if hidden.
    test -n "$FZF_CTRL_T_COMMAND"; or set -l FZF_CTRL_T_COMMAND "
    command find -L \$dir -mindepth 1 \\( -path \$dir'*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 's@^\./@@'"

    test -n "$FZF_TMUX_HEIGHT"; or set FZF_TMUX_HEIGHT 40%
    begin
        set -lx FZF_DEFAULT_OPTS "--height $FZF_TMUX_HEIGHT --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS"
        eval "$FZF_CTRL_T_COMMAND | "(__fzfcmd)' -m --query "'$fzf_query'"' | while read -l r
            set result $result $r
        end
    end
    if test -z "$result" 
        commandline -f repaint
        return
    else
        # Remove last token from commandline.
        commandline -t ""
    end
    commandline -it -- "$EDITOR "
    for i in $result
        commandline -it -- (string escape $i)
        commandline -it -- ' '
    end
    commandline -f execute
end
