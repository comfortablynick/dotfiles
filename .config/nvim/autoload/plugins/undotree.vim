let s:guard = 'g:loaded_autoload_plugins_undotree' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Show tree on right + diff below
let g:undotree_WindowLayout = 4
