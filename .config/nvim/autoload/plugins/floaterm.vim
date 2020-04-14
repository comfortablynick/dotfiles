let s:guard = 'g:loaded_autoload_plugins_floaterm' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#floaterm#post() abort
    " let g:floaterm_wintitle = v:false

    hi link Floaterm NormalFloat
    hi link FloatermBorder NormalFloat
endfunction
