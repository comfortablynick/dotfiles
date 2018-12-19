function _sorin_git_info
    if not command -sq git
        set_color normal
        return
    end

    # Get the git directory for later use.
    # Return if not inside a Git repository work tree.
    if not set -l git_dir (command git rev-parse --git-dir 2>/dev/null)
        set_color normal
        return
    end

    # Get the current action ("merge", "rebase", etc.)
    # and if there's one get the current commit hash too.
    set -l commit ''
    if set -l action (fish_print_git_action "$git_dir")
        set commit (command git rev-parse HEAD 2> /dev/null | string sub -l 7)
    end

    # Get either the branch name or a branch descriptor.
    set -l branch_detached 0
    if not set -l branch (command git symbolic-ref --short HEAD 2>/dev/null)
        set branch_detached 1
        set branch (command git describe --contains --all HEAD 2>/dev/null)
    end

    # Get the commit difference counts between local and remote.
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

    # git-status' porcelain v1 format starts with 2 letters on each line:
    #   The first letter (X) denotes the index state.
    #   The second letter (Y) denotes the working directory state.
    #
    # The following table presents the possible combinations:
    # * The underscore character denotes whitespace.
    # * The cell values stand for the following file states:
    #   a: added
    #   d: deleted
    #   m: modified
    #   r: renamed
    #   u: unmerged
    #   t: untracked
    # * Cells with more than one letter signify that both states
    #   are simultaneously the case. This is possible since the git index
    #   and working directory operate independently of each other.
    # * Cells which are empty are unhandled by this code.
    # * T (= type change) is undocumented.
    #   See Git v1.7.8.2 release notes for more information.
    #
    #   \ Y→
    #  X \
    #  ↓  | A  | C  | D  | M  | R  | T  | U  | X  | B  | ?  | _
    # ----+----+----+----+----+----+----+----+----+----+----+----
    #  A  | u  |    | ad | am | r  | am | u  |    |    |    | a
    #  C  |    |    | ad | am | r  | am | u  |    |    |    | a
    #  D  |    |    | u  | am | r  | am | u  |    |    |    | a
    #  M  |    |    | ad | am | r  | am | u  |    |    |    | a
    #  R  | r  | r  | rd | rm | r  | rm | ur | r  | r  | r  | r
    #  T  |    |    | ad | am | r  | am | u  |    |    |    | a
    #  U  | u  | u  | u  | um | ur | um | u  | u  | u  | u  | u
    #  X  |    |    |    | m  | r  | m  | u  |    |    |    |
    #  B  |    |    |    | m  | r  | m  | u  |    |    |    |
    #  ?  |    |    |    | m  | r  | m  | u  |    |    | t  |
    #  _  |    |    | d  | m  | r  | m  | u  |    |    |    |

    set -l status_added 0
    set -l status_deleted 0
    set -l status_modified 0
    set -l status_renamed 0
    set -l status_unmerged 0
    set -l status_untracked 0
    for line in (command git status --porcelain | string sub -l 2)
        # Check unambiguous cases first which allows us
        # to skip running all the other regexps.
        if test "$line" = '??'
            set status_untracked (math $status_untracked + 1)
            continue
        end
        if string match -r '^(?:AA|DD|U.|.U)$' "$line" >/dev/null
            set status_unmerged (math $status_unmerged + 1)
            continue
        end
        if string match -r '^(?:[ACDMT][ MT]|[ACMT]D)$' "$line" >/dev/null
            set status_added (math $status_added + 1)
        end
        if string match -r '^[ ACMRT]D$' "$line" >/dev/null
            set status_deleted (math $status_deleted + 1)
        end
        if string match -r '^.[MT]$' "$line" >/dev/null
            set status_modified (math $status_modified + 1)
        end
        if string match -e 'R' "$line" >/dev/null
            set status_renamed (math $status_renamed + 1)
        end
    end


    if test -n "$branch"
        set -l color
        if test $branch_detached -ne 0
            set color $sorin_color_magenta
        else
            set color $sorin_color_green
        end
        echo -n " $color$branch"
    end

    set -l space ''

    if test -n "$commit"
        echo -n "$space$sorin_color_yellow$commit"
    end
    if test -n "$action"
        set_color normal
        echo -n "$sorin_color_white:$sorin_color_red$action"
    end
    if test $status_ahead -ne 0
        echo -n "$sorin_color_white$sorin_symbol_git_ahead$status_ahead"
    end
    if test $status_behind -ne 0
        echo -n "$space$sorin_color_white$sorin_symbol_git_behind"
    end
    if test $status_ahead -ne 0 -o $status_behind -ne 0
        echo -n "$space$sorin_color_white$sorin_symbol_git_separator"
    end
    if test $status_stashed -ne 0
        echo -n "$space$sorin_color_cyan$sorin_symbol_git_stashed"
    end
    if test $status_added -ne 0
        echo -n "$space$sorin_color_green$sorin_symbol_git_added$status_added"
    end
    if test $status_deleted -ne 0
        echo -n "$space$sorin_color_red$sorin_symbol_git_deleted$status_deleted"
    end
    if test $status_modified -ne 0
        echo -n "$space$sorin_color_cyan$sorin_symbol_git_modified$status_modified"
    end
    if test $status_renamed -ne 0
        echo -n "$space$sorin_color_magenta$sorin_symbol_git_renamed$status_renamed"
    end
    if test $status_unmerged -ne 0
        echo -n "$space$sorin_color_yellow$sorin_symbol_git_unmerged$status_unmerged"
    end
    if test $status_untracked -ne 0
        echo -n "$space$sorin_color_blue$sorin_symbol_git_untracked$status_untracked"
    end
    set -g sorin_git_changes (math $status_stashed + $status_added + $status_deleted + $status_modified + $status_renamed + $status_unmerged + $status_untracked)
    if test $sorin_git_changes -eq 0
        echo -n "$space$sorin_color_green$sorin_symbol_git_clean"
    end

    set_color normal
end
