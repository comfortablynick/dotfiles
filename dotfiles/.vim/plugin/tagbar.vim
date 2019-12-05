" ====================================================
" Filename:    plugin/tagbar.vim
" Description: Tagbar tag explorer lazy load/config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-05
" ====================================================
if exists('g:loaded_plugin_tagbar_8ftwpz9y') | finish | endif
let g:loaded_plugin_tagbar_8ftwpz9y = 1

let g:tagbar_autoclose = 1                                      " Autoclose tagbar after selecting tag
let g:tagbar_autofocus = 1                                      " Move focus to tagbar when opened
let g:tagbar_compact = 1                                        " Eliminate help msg, blank lines
let g:tagbar_autopreview = 0                                    " Open preview window with selected tag details
let g:tagbar_sort = 0                                           " Sort tags alphabetically vs. in file order

" Filetypes
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }


function! s:tagbar_toggle() abort
    packadd tagbar
    TagbarToggle
endfunction

" Maps
nnoremap <silent> <Leader>t :call <SID>tagbar_toggle()<CR>
noremap <silent> <F8> :call <SID>tagbar_toggle()<CR>
