let s:guard = 'g:loaded_autoload_plugins_netrw' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:netrw_set_opts = 1
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = -30 " Absolute
let g:netrw_banner = 0
let g:netrw_list_hide = &wildignore
let g:netrw_sort_sequence = '[\/]$,*' " Directories on the top, files below
