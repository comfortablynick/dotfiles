" ====================================================
" Filename:    plugin/quickfix.vim
" Description: Quickfix/loclist config
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_plugin_quickfix' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Defaults
let g:quickfix_size = 20

" Close qf after lint if empty
" augroup plugin_quickfix
"     autocmd!
"     autocmd FileType qf wincmd J
" augroup end

" Toggle quickfix
nnoremap <silent> Q :call quickfix#toggle()<CR>
nnoremap <silent> cq :call quickfix#toggle()<CR>
