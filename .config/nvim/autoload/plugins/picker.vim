let s:guard = 'g:loaded_autoload_plugins_picker' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#picker#post() abort
    let g:picker_custom_find_executable = 'fd'
    let g:picker_custom_find_flags = '-t f -HL --color=never'
endfunction
