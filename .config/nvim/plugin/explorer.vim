" ====================================================
" Filename:    plugin/explorer.vim
" Description: Project file explorers
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_plugin_explorer' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:use_explorer = 'rnvimr'
let g:use_explorer_coc = 'rnvimr'

" Commands
command! -nargs=0 NERDTreeToggle call plugins#lazy_run('NERDTreeToggle', 'nerdtree')
command! -nargs=0 TagbarToggle call plugins#tagbar#toggle()
command! -nargs=0 RnvimrToggle call plugins#lazy_run('RnvimrToggle', 'rnvimr')
command! -nargs=0 DefxToggle
    \ call plugins#lazy_run('Defx -toggle -split=vertical -winwidth=30 -direction=topleft', 'defx.nvim')
command! -nargs=0 NetrwToggle call explorer#toggle('netrw')

" vim-floaterm wrappers
command! -nargs=* Lf call plugins#floaterm#wrap('lf', <f-args>)
command! -nargs=* Ranger call plugins#floaterm#wrap('ranger', <f-args>)

if has('nvim')
    command! -nargs=0 LuaTreeToggle
        \ call plugins#lazy_run(
        \ 'LuaTreeToggle',
        \ 'nvim-tree.lua',
        \ {'config': 'lua require"tree".on_enter()'}) 
endif

" Maps
nnoremap <silent>    <C-E>  :call explorer#toggle(g:use_explorer)<CR>
nnoremap <silent> <Leader>n :call explorer#toggle(g:use_explorer)<CR>
