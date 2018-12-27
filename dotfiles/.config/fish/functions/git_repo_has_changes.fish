# Defined in /tmp/fish.Dfu8YB/git_repo_has_changes.fish @ line 2
function git_repo_has_changes --description 'fetch git repo and determine if changes have been made' --argument git_dir
	git -C "$git_dir" fetch
    set -l head_hash (git -C "$git_dir" rev-parse HEAD)
    set -l upstream_hash (git -C "$git_dir" rev-parse 'master@{upstream}')

    test "$head_hash" != "$upstream_hash"
    and return 0
    or return 1
end
