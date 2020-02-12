# Defined in /tmp/fish.nEBgfg/cdg.fish @ line 2
function b --description 'Fuzzy cd to bookmarked directories'
    if test -n "$CDG_PATH"
        string join -- \n $CDG_PATH | fzy | read -l target_dir
        test -n "$target_dir"
        and cd $target_dir
    else
        echo '$CDG_PATH needed for bookmarks!'
    end
end
