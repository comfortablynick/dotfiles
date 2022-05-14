function speedtest --description 'Run official speedtest cli if available, else use python version'
    set official_cli /usr/bin/speedtest /opt/homebrew/bin/speedtest
    for cli in $official_cli
        if test -x $cli
            $cli $argv
            return
        end
    end
    command speedtest $argv
end
