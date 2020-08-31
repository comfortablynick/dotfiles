let s:guard = 'g:loaded_autoload_plugins_asynctasks' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:asynctasks_extra_config = [
    \ '~/.config/nvim/tasks.ini',
    \ ]
let g:asynctasks_profile = 'release'
let g:asynctasks_term_pos = 'floaterm'
