# Defined in /tmp/fish.7U1VwY/d.fish @ line 2
function d --description 'alias for lsd with settings'
    set -l cmd "command lsd -alF --group-dirs first --date relative"
    if test $MOSH_CONNECTION -eq 1
        set cmd "$cmd --icon never"
    end
    eval $cmd
end
