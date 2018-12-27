# Defined in /tmp/fish.5f1E2h/git_status.fish @ line 2
function git_status --description 'Parses and counts output of `git status`'
	set_var_default __fish_git_prompt_symbol_prehash ':'
    set_var_default __fish_git_prompt_tag_symbol ''

    set -l gstat (command git status --porcelain --branch 2>/dev/null)
    set -l branch (string match -r '^##\s(.+)\.\.\.' -- $gstat)[2]

    if test -z "$branch"
        # Detatched
        # Get tag
        set branch (command git describe --exact-match 2>/dev/null)
        test -n "$branch"
        # Get hash
        or set branch "$__fish_git_prompt_symbol_prehash"(command git rev-parse --short HEAD)
    end

    set -l added (count (string match -r '^[ACDMT] ' -- $gstat))
    set -l deleted (count (string match -r '^[ACMRT ]D' -- $gstat))
    set -l modified (count (string match -r '^.[MT]' -- $gstat))
    set -l renamed (count (string match 'R' -- $gstat))
    set -l unmerged (count (string match -r '^(?:AA|DD|U.|.U)' -- $gstat))
    set -l untracked (count (string match -r '^\?\?' -- $gstat))

    # set -l changes (command git diff --numstat | awk '{ added += $1; removed += $2 } END { print "+" added "/-" removed }')
    # set changes (echo "$changes " | string replace -r '(\+0/(-0)?|/-0)' '')

    set -l changes (command git diff --numstat | awk '{ added += $1; removed += $2 } END { print added " " removed }')
    set -l diff (string split ' ' "$changes" )
    set -l plus (math "$diff[1]" + 0)
    set -l minus (math "$diff[2]" + 0)

    echo $branch\n$added\n$deleted\n$modified\n$renamed\n$unmerged\n$untracked\n$plus\n$minus
end
