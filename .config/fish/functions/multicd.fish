function multicd --description 'Function used with cd abbr (.. ... etc)'
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
