# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.9Ms1j7/update_neovim.fish @ line 2
function update_neovim --description 'pull neovim source and build' --argument src_dir
	set -l src_dir "$HOME/src/neovim"
    git -C "$src_dir" fetch
    set -l head_hash (git -C "$src_dir" rev-parse HEAD)
    set -l upstream_hash (git -C "$src_dir" rev-parse 'master@{upstream}')
    if test "$head_hash" != "$upstream_hash"
        git -C "$src_dir" reset --hard origin/master;
        and _build:neovim "$src_dir"
    else
        echo "Aborted: neovim repo has no upstream changes."
    end
end
