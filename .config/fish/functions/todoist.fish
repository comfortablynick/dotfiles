function todoist --description 'alias for todoist --color --indent with default list'
    set -l cmd todoist
    if status is-interactive
        set -a cmd --color --header --indent
    end
    if not set -q argv[1]
        set -a cmd list
    end
    command $cmd $argv
end
