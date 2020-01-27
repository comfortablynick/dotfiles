if exists('g:loaded_autoload_plugins_clever_f') | finish | endif
let g:loaded_autoload_plugins_clever_f = 1

function! plugins#clever_f#post() abort
    let g:clever_f_smart_case = 1
    let g:clever_f_chars_match_any_signs = ';'
endfunction
