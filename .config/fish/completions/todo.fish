# Completion for todo.sh

# All subcommands
set -l all_subcmds add a addto addm append app archive command del rm depri dp
set -a all_subcmds do help list ls listaddons listall lsa listcon lsc listfile
set -a all_subcmds lf listpri lsp listproj lsprj move mv prepend prep pri p
set -a all_subcmds replace report shorthelp

function __fish_todo_subcommand -d 'get completion for todo.sh subcommand'
    set subcommand $argv[1]
    set -e argv[1]
    complete -f -c todo -n "not __fish_seen_subcommand_from $all_subcmds" -a $subcommand $argv
end

function __fish_todo_option
    set subcommand $argv[1]
    set -e argv[1]
    complete -f -c todo -n "__fish_seen_subcommand_from $subcommand" $argv
end

complete -c todo -n __fish_use_subcommand -x -s h -d 'Print help information'
complete -c todo -n __fish_use_subcommand -x -s v -d 'Print version'

# Subcommands
# complete -c todo -n __fish_use_subcommand -xa 'add a' -d 'add todo item'
__fish_todo_subcommand 'add a' -r -d 'add todo item'
__fish_todo_subcommand addm -r -d 'add multiple todo items'
__fish_todo_subcommand addto -r -d 'add todo to any file located in todo.txt dir'
__fish_todo_subcommand 'append app' -r -d 'append text to end of task'
__fish_todo_subcommand archive -r -d 'move all done tasks to done.txt'
__fish_todo_subcommand command -r -d 'run remaining arguments using only todo.sh builtins'
__fish_todo_subcommand 'del rm' -r -d 'delete task'
__fish_todo_subcommand deduplicate -d 'remove duplicate lines from todo.txt'
__fish_todo_subcommand 'depri dp' -r -d 'remove priority from the tasks'
__fish_todo_subcommand 'done do' -r -d 'mark tasks as done'
__fish_todo_subcommand help -r -d 'display help about usage, options, or help for passed actions'
__fish_todo_subcommand 'list ls' -r -d 'display all tasks that contain passed text'
__fish_todo_subcommand 'listall lsa' -r -d 'display all lines in todo.txt and done.txt that contain passed text'
__fish_todo_subcommand listaddons -r -d 'display actions from action directory'
__fish_todo_subcommand 'listcon lsc' -r -d 'list all contexts that start with @ in todo.txt'
__fish_todo_subcommand 'listfile lf' -r -d 'display all lines in src file'
__fish_todo_subcommand 'listpri lsp' -r -d 'display all tasks with given priority'
__fish_todo_subcommand 'listproj lsprj' -r -d 'list all projects that start with + in todo.txt'
__fish_todo_subcommand 'move mv' -r -d 'move line from src file to dest file'
__fish_todo_subcommand 'prepend prep' -r -d 'add text to beg of task'
__fish_todo_subcommand 'pri p' -r -d 'add priority A-Z to task'
__fish_todo_subcommand replace -r -d 'replace task with updated todo'
__fish_todo_subcommand report -r -d 'add number of open tasks and done tasks to report.txt'
__fish_todo_subcommand shorthelp -r -d 'list one-line usage of all actions'

# complete -f -c todo -n _fish_use_subcommand 
