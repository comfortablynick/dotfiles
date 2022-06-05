function tmpfish --wraps=fish --description 'Start fish with a temporary environment and clean up after'
    env -i HOME=(mktemp -d) PATH="$PATH" SHLVL=$SHLVL TERM=$TERM TERMINFO=$TERMINFO fish -C '
        function _tmpfish_cleanup -V HOME -e fish_exit
            echo Cleaning up (set_color -o)$HOME(set_color normal)
            command rm -rf $HOME
        end
        builtin cd $HOME
    ' $argv
end
