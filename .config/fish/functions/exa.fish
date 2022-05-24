function exa --description 'Run exa with defaults' --wraps exa
    command exa -la --group-directories-first --icons --color-scale --color=always $argv | bat -p
end
