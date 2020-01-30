" ====================================================
" Filename:    plugin/completion.vim
" Description: Autocompletion plugin handling
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-30 09:08:27 CST
" ====================================================
if exists('g:loaded_plugin_completion') | finish | endif
let g:loaded_plugin_completion = 1

let g:completion_filetypes = get(g:, 'completion_filetypes', {})
let g:coc_filetypes = get(g:completion_filetypes, 'coc', [])

augroup plugin_completion
    autocmd!
    if !empty(g:coc_filetypes)
        autocmd FileType * if index(g:coc_filetypes, &ft) > -1|call completion#coc()|endif
        autocmd User CocNvimInit ++once call completion#coc_init()
    endif
augroup END
