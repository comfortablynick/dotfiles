function thefuck-command-line -d 'Bind to a key to automatically populate fixed command'
    set -x THEFUCK_REQUIRE_CONFIRMATION 0
    set fuck (thefuck $history[1] 2>/dev/null)
    if test -n $fuck
        history delete $history[1] -eC
        commandline -r $fuck
    end
end
