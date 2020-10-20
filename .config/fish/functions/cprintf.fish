# Defined in /tmp/fish.E3ONEB/cprintf.fish @ line 2
function cprintf --description 'Printf with colors' --argument text
    set -l text (string split '<' $text | string split '>')
    set -e argv[1]
    set -l pieces (
    for a in $text
        set -l elem (string split : $a)
        switch $elem[1]
            case b
                set_color -o
            case u
                set_color -u
            case bl
                printf "\e[5m"
            case fg
                set_color $elem[2]
            case bg
                set_color -b $elem[2]
            case /b
                printf "\e[22m"
            case /u
                printf "\e[24m"
            case /bl
                printf "\e[25m"
            case /fg
                printf "\e[39m"
            case /bg
                printf "\e[49m"
            case \*
                echo -n $a
        end
    end
    )
    printf "$pieces"\n $argv
end
