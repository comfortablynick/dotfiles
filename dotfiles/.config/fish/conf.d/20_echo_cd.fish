function echo_cd --on-variable PWD --description 'echo directory listing on change'
    if set -q LS_AFTER_CD
        and test $LS_AFTER_CD -eq 1
        # execute `ls` when changing directories
        if test "$PWD" != "$HOME"
            ls
        end
    end
end
