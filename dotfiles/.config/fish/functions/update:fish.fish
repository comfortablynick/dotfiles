# Defined in /tmp/fish.vcSBhu/update:fish.fish @ line 2
function update:fish --description 'Pull fish source and build'
	set -l src_dir "$HOME/src/fish-shell"
    git -C "$src_dir" fetch
    set -l head_hash (git -C "$src_dir" rev-parse HEAD)
    set -l upstream_hash (git -C "$src_dir" rev-parse 'master@{upstream}')
    if test "$head_hash" != "$upstream_hash"
        git -C "$src_dir" reset --hard origin/master;
        and _build:fish
    else
        echo "Aborted: fish-shell repo has no upstream changes."
    end
end
