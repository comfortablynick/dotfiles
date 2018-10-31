#!/usr/bin/env fish
function git_status -d "retrieve git repo info from vcprompt util"
    set -l repo ""
    set -l branch ""
    set -l revision ""
    set -l untracked ""
    set -l modified ""

    # Call vcprompt
    set -l vcp_output (vcprompt -f "repo:%n branch:%b revision:%r untracked:%u modified:%m" | string split ' ')
    for arg in $vcp_output
        set -l arg_pair (string split ':' $arg)
        set -l arg_name $arg_pair[1]
        set -l arg_val $arg_pair[2]
        switch "$arg_name"
            case "repo"
                set repo $arg_val
            case "branch"
                set branch $arg_val
            case "revision"
                set revision $arg_val
            case "untracked"
                set untracked $arg_val
            case "modified"
                set modified $arg_val
            case "*"
        end
    end
    printf "$repo $branch $revision $untracked $modified"
end
