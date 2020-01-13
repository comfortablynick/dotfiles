" ====================================================
" Filename:    plugin/tags.vim
" Description: Tag/symbol navigation settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-13 08:34:16 CST
" ====================================================
if exists('g:loaded_plugin_tags_8ftwpz9y')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_tags_8ftwpz9y = 1

" Lazy load tagbar (command will be replaced on first call)
command -nargs=0 TagbarToggle call config#tagbar#tagbar_toggle()

nnoremap <silent> <Leader>t :Clap tags<CR>
" nnoremap <silent> <Leader>t :TagbarToggle<CR>
