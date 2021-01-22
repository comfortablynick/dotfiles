# Defined in /var/folders/09/rfyz42rn67z2lg9jnw0gs9240000gn/T//fish.ycy2Jz/todoist.fish @ line 2
function todoist --description 'alias for todoist --color with default list'
    set -l cmd todoist
    if status is-interactive
        set -a cmd --color --header
    end
    if not set -q argv[1]
        set -a cmd list
    end
    command $cmd $argv
end
