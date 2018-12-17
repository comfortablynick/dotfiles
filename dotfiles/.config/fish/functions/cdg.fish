# Defined in /tmp/fish.VOsCKa/cdg.fish @ line 2
function cdg --description 'choose cd bookmarks with fzf'
	if test -n "$CDG_PATH"
        string join -- \n $CDG_PATH | eval (__fzfcmd) | read -l target_dir
        test -n "$target_dir"
        and cd (eval "$target_dir")
    else
        echo '$CDG_PATH needed for bookmarks!'
    end
end
