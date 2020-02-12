# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.Qv3sQC/update:neovim.fish @ line 2
function update:neovim --description 'pull neovim source and build' --argument src_dir
    # Disable CD echo if it's set
    set -q LS_AFTER_CD
    and set LS_AFTER_CD 0

	set -l src_dir "$HOME/src/neovim"
    if git_repo_has_changes "$src_dir"
        git -C "$src_dir" reset --hard origin/master;
        and _build:neovim "$src_dir"
    else
        echo "Aborted: neovim repo has no upstream changes."
    end

    # Re-enable CD echo
    set -q LS_AFTER_CD
    and set LS_AFTER_CD 1
end
