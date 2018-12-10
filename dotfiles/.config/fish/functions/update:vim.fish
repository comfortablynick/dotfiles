# Defined in /tmp/fish.NYaGYo/update:vim.fish @ line 2
function update:vim --description 'pull vim source and build if there are changes'
	set -l src_dir "$HOME/src/vim"
    git -C "$src_dir" fetch
    set -l head_hash (git -C "$src_dir" rev-parse HEAD)
    set -l upstream_hash (git -C "$src_dir" rev-parse 'master@{upstream}')
    if test "$head_hash" != "$upstream_hash"
        git -C "$src_dir" reset --hard origin/master

        and _build:vim "$src_dir"
    else
        echo "Aborted: vim repo has no upstream changes."
    end
end
