# User functions that are executed with fish hooks (events)
# Query these with `functions --handlers`
function __echo_cd --on-variable PWD --description 'echo directory listing on change'
    status --is-command-substitution; and return
    if set -q LS_AFTER_CD
        and test $LS_AFTER_CD -eq 1
        and test -n "$LS_AFTER_CD_COMMAND"
        if test "$PWD" != "$HOME"
            eval "$LS_AFTER_CD_COMMAND"
        end
    end
end
