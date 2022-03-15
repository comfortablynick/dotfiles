function speedtest --description 'Run official speedtest cli if available, else use python version'
    set official_cli /usr/bin/speedtest
    if test -x $official_cli
        $official_cli $argv
    else
        command speedtest $argv
    end
end
