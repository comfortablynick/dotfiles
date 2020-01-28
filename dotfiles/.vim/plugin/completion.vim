" ====================================================
" Filename:    plugin/completion.vim
" Description: Autocompletion plugin handling
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-27 17:39:50 CST
" ====================================================
if exists('g:loaded_plugin_completion') | finish | endif
let g:loaded_plugin_completion = 1

let g:completion_filetypes = get(g:, 'completion_filetypes', {})
let g:coc_filetypes = get(g:completion_filetypes, 'coc', [])

function! s:coc() abort
    packadd coc.nvim
endfunction

augroup plugin_completion
    autocmd!
    if !empty(g:coc_filetypes)
        autocmd FileType *
            \ if index(g:coc_filetypes, &ft) > -1
            \ | packadd coc.nvim
            \ | endif
    endif
augroup END
