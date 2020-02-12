# Defined in /tmp/fish.NXhJp2/update:vim.fish @ line 2
function update:vim --description 'pull vim source and build if there are changes'
    # Disable CD echo if it's set
    set -q LS_AFTER_CD
    and set LS_AFTER_CD 0

    set -l src_dir "$HOME/src/vim"
    if git_repo_has_changes "$src_dir"
        git -C "$src_dir" reset --hard origin/master
        and _build:vim "$src_dir"
    else
        echo "Aborted: vim repo has no upstream changes."
    end

    # Re-enable CD echo
    set -q LS_AFTER_CD
    and set LS_AFTER_CD 1
end
