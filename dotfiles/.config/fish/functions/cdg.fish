# Defined in /tmp/fish.OKtOVK/cdg.fish @ line 2
function cdg --description 'choose cd bookmarks with fzf'
	set -l cdg_file "$__fish_config_dir/cdg_paths"
    if test -f "$cdg_file"
        set -l --path target_paths (head $cdg_file | string match -r '^(?!#)\S+' ) # | eval (__fzfcmd))
        for p in $target_paths
            echo "$p"
        end
        # cd (eval "$target_dir")
    end
end
