# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.g34FL5/fzf_cdhist.fish @ line 2
function fzf_cdhist --description 'cd to one of the previously visited locations'
	set -l buf
    for i in (seq 1 (count $dirprev))
        [ $i -eq 0 ]; and return 1
        set -l dir $dirprev[$i]
        # Make sure dir exists and is not a duplicate
        if test -d $dir #; and not contains $dir $buf
            set -a buf $dir
        end
    end
    set dirprev $buf
    set -l read_cmd

    # MacOS doesn't have `tac`
    switch (uname)
        case Darwin
            set read_cmd tail -r
        case '*'
            set read_cmd tac
    end

    string join \n $dirprev | $read_cmd | sed 1d | eval (__fzfcmd) +m --tiebreak=index --toggle-sort=ctrl-r $FZF_CDHIST_OPTS | read -l result
    [ "$result" ]; and cd $result
    commandline -f repaint
end
