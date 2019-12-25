" ====================================================
" Filename:    plugin/lsp.vim
" Description: Config for builtin nvim lsp
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-24
" ====================================================
if exists('g:loaded_plugin_lsp_5sjdin1r') | finish | endif
let g:loaded_plugin_lsp_5sjdin1r = 1

augroup plugin_lsp_5sjdin1r
    autocmd!
augroup END

if exists('g:completion_filetypes')
    let lsp_filetypes = join(get(g:, 'completion_filetypes', {})['nvim-lsp'], ',')

    if !empty(lsp_filetypes)
        execute printf('autocmd plugin_lsp_5sjdin1r FileType %s call config#lsp#init()',
            \ lsp_filetypes)
    endif
endif
