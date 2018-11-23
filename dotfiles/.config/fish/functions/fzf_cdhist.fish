# Defined in /tmp/fish.yeNaFL/fzf_cdhist.fish @ line 2
function fzf_cdhist --description 'cd to one of the previously visited locations'
	set -l buf
    # if test -z "$dirprev[1]"
    #     echo "No history: need to cd first"
    #     return 1
    # end
    for i in (seq 1 (count $dirprev))
        set -l dir $dirprev[$i]
        if test -d $dir
            set -a buf $dir
        end
    end
    set dirprev $buf
    string join \n $dirprev | tac | sed 1d | eval (__fzfcmd) +m --tiebreak=index --toggle-sort=ctrl-r $FZF_CDHIST_OPTS | read -l result
    [ "$result" ]; and cd $result
    commandline -f repaint
end
