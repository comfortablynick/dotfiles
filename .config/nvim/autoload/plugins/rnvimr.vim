let s:guard = 'g:loaded_autoload_plugins_rnvimr' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Close ranger after picking file
let g:rnvimr_enable_picker = 1
