# Defined in /tmp/fish.zw6ahS/git.fish @ line 2
function git --description 'alias git=hub'
    if builtin pwd -P | string match -qr "^$HOME"
        and not command git rev-parse --show-toplevel &>/dev/null

        set_color blue --bold
        echo 'NOTE: using yadm git'
        set_color normal

        yadm $argv
        return
    end
    hub $argv
end
