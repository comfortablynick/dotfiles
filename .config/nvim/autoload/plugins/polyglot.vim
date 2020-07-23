let s:guard = 'g:loaded_autoload_plugins_polyglot' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#polyglot#pre() abort
    " Don't use polyglot syntax files for these filetypes
    let g:polyglot_disabled = [
        \ 'markdown',
        \ 'asciidoc',
        \ ]
endfunction
