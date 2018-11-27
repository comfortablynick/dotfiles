# Defined in /tmp/fish.EfqnyD/fzf_cdhist.fish @ line 2
function fzf_cdhist --description 'cd to one of the previously visited locations'
	if set -q argv[1]
        cd $argv
        return
    end

    set -l all_dirs $dirprev $dirnext
    if not set -q all_dirs[1]
        echo (_ 'No previous directories to select. You have to cd at least once.') >&2
        return 0
    end

    # Reverse the directories so the most recently visited is first in the list.
    # Also, eliminate duplicates; i.e., we only want the most recent visit to a
    # given directory in the selection list.
	set -l uniq_dirs
    for dir in $all_dirs[-1..1]
        if test -d $dir -a "$dir" != "$PWD"
            # Replace $HOME with ~ for readability
            # TODO: put it back to make cd work
            set -l home_dir (string match -r "^$HOME(/.*|\$)" "$dir")
            if set -q home_dir[2]
                set dir "~$home_dir[2]"
            end
            if not contains $dir $uniq_dirs
                set -a uniq_dirs $dir
            end
        end
    end

    # Pipe unique dirs to fzf
    string join \n $uniq_dirs | eval (__fzfcmd) +m --tiebreak=index --toggle-sort=ctrl-r $FZF_CDHIST_OPTS | read -l result
    if test -n "$result"
        set -l home_path (string match -r "^~(.*)" "$result")
        if set -q home_path[2]
            set result "$HOME$home_path[2]"
        end
    end
    commandline -f repaint
end
