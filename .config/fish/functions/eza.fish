function eza --description 'Run eza with defaults' --wraps eza
    command eza -la --group-directories-first --icons --color-scale $argv
end
