function git --description 'alias git=hub'
    if command -q hub
        hub $argv
    else
        command git $argv
    end
end
