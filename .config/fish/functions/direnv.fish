function direnv --description 'Wrapper for direnv tool'
    if command -q direnv
        command direnv $argv
    else
        asdf exec direnv $argv
    end
end
