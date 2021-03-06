# Defined in /tmp/fish.9s5QH4/d.fish @ line 2
function d --description 'alias for lsd with settings'
    set -l cmd "command lsd -AlF --group-dirs first --date relative"
    if set -q MOSH_CONNECTION; and test $MOSH_CONNECTION -eq 1
        set cmd "$cmd --icon never"
    end
    eval $cmd $argv
end
