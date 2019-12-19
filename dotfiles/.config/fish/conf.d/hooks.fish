# User functions that are executed with fish hooks (events)
# Query these with `functions --handlers`
function __echo_cd --on-variable PWD --description 'echo directory listing on change'
    status --is-command-substitution
    and return
    if set -q LS_AFTER_CD
        and test $LS_AFTER_CD -eq 1
        and test -n "$LS_AFTER_CD_COMMAND"
        if test "$PWD" != "$HOME"
            eval "$LS_AFTER_CD_COMMAND"
        end
    end
end

# delete failed command history
function __remove_failed_command_history --on-event fish_postexec --description 'delete failed command from history'
    set -l cmd_status $status
    status --is-command-substitution
    and return

    if test $cmd_status -ne 0
        set -l cmd (string trim -r $argv)
        test -z "$cmd"
        and return
        history delete -eC -- (string trim -r $argv)
        echo "command deleted from history: `$cmd' (Status $cmd_status)"

    end
end
