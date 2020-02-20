if exists('g:loaded_autoload_plugins_webdevicons') | finish | endif
let g:loaded_autoload_plugins_webdevicons = 1

scriptencoding utf-8
function! plugins#webdevicons#post() abort
    let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['todo.txt'] = '🗹'
endfunction
