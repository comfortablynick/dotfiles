# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.Q6QFeF/fzf_cdhist.fish @ line 2
function fzf_cdhist --description 'cd to one of the previously visited locations'
	set -l buf
    for i in (seq 1 (count $dirprev))
        [ $i -eq 0 ]; and return 1
        set -l dir $dirprev[$i]
        if test -d $dir
            set -a buf $dir
        end
    end
    set dirprev $buf
    string join \n $dirprev | tail -r | sed 1d | eval (__fzfcmd) +m --tiebreak=index --toggle-sort=ctrl-r $FZF_CDHIST_OPTS | read -l result
    [ "$result" ]; and cd $result
    commandline -f repaint
end
