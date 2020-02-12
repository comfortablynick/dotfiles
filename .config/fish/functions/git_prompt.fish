# Defined in /tmp/fish.8zEwpZ/git_prompt.fish @ line 2
function git_prompt --description 'display git repo info'
	set -l git_status (git_status)
    set -l branch $git_status[1]
    set -l added $git_status[2]
    set -l deleted $git_status[3]
    set -l modified $git_status[4]
    set -l renamed $git_status[5]
    set -l unmerged $git_status[6]
    set -l untracked $git_status[7]
    set -l plus $git_status[8]
    set -l minus $git_status[9]

    test -z "$branch"
    and return

    command git rev-list --count --left-right 'HEAD...@{upstream}' 2>/dev/null \
        | read -d \t -l status_ahead status_behind
    if test $status -ne 0
        set status_ahead 0
        set status_behind 0
    end

    # Get the stash status.
    # (git stash list) is very slow. => Avoid using it.
    set -l status_stashed 0
    if test -f "$git_dir/refs/stash"
        set status_stashed 1
    else if test -r "$git_dir/commondir"
        read -l commondir <"$git_dir/commondir"
        if test -f "$commondir/refs/stash"
            set status_stashed 1
        end
    end
    # Format output
    set -l format $argv[1]
    if test -z "$format"
        set format " (%s)"
    end

    printf $format $branch
end
