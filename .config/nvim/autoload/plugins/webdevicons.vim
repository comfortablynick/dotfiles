let s:guard = 'g:loaded_autoload_plugins_webdevicons' | if exists(s:guard) | finish | endif
let {s:guard} = 1

scriptencoding utf-8

function! plugins#webdevicons#post() abort
    " post() needed because we have to update variable defined by plugin
    let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['todo.txt'] = '🗹'
endfunction
