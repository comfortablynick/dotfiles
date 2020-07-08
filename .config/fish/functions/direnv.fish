# Defined in /tmp/fish.dtuF6A/direnv.fish @ line 2
function direnv --description 'Wrapper for direnv tool'
    if command -q direnv
        command direnv $argv
    else
        asdf exec direnv $argv
    end
end
