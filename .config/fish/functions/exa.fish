function exa --description 'Run exa with defaults' --wraps exa
    command eza -la --group-directories-first --icons --color=always $argv
end
