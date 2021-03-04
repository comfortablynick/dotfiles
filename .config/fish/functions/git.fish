# Defined in /tmp/fish.RyWOtV/git.fish @ line 2
function git --description 'alias git=hub'
    if builtin pwd -P | string match -qr "^$HOME"
        and not command git rev-parse --show-toplevel 2&>/dev/null

        set_color blue --bold
        echo 'NOTE: using yadm git'
        set_color normal

        yadm $argv
        return
    end
    hub $argv
end
