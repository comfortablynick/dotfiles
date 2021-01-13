# Defined in /tmp/fish.sbBqBe/todoist.fish @ line 2
function todoist --description 'alias for todoist --color with default list'
    set -l cmd 'command todoist'
    if status is-interactive
        set -a cmd '--color' '--header'
    end
    if not set -q argv[1]
        set -a cmd 'list'
    end
    eval $cmd $argv
end
