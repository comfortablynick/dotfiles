# Defined in /var/folders/09/rfyz42rn67z2lg9jnw0gs9240000gn/T//fish.8A3osf/direnv.fish @ line 2
function direnv --description 'Wrapper for direnv tool'
    if command -q direnv
        command direnv $argv
    else
        asdf exec direnv $argv
    end
end
