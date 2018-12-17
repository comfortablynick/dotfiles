# Defined in /tmp/fish.PxOoaY/update:fish.fish @ line 2
function update:fish --description 'Pull fish source and build'
	
    set -q LS_AFTER_CD
    and set LS_AFTER_CD 0

    set -l src_dir "$HOME/src/fish-shell"
    if git_repo_has_changes "$src_dir"
        git -C "$src_dir" reset --hard origin/master
        and _build:fish
    else
        echo "Aborted: fish-shell repo has no upstream changes."
    end

    # Re-enable CD echo
    set -q LS_AFTER_CD
    and set LS_AFTER_CD 1
end
