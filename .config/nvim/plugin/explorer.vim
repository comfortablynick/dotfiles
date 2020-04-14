" ====================================================
" Filename:    plugin/explorer.vim
" Description: Project file explorers
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_plugin_explorer' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:use_explorer = 'netrw'             " netrw/nerdtree/defx/coc-explorer (set from coc config)
let g:use_explorer_coc = 'coc-explorer' " use with coc.nvim

" Commands
command! -nargs=0 NERDTreeToggle packadd nerdtree | NERDTreeToggle
command! -nargs=0 TagbarToggle call plugins#tagbar#toggle()
command! -nargs=0 RnvimrToggle packadd rnvimr | RnvimrToggle
command! -nargs=0 DefxToggle call explorer#toggle('defx')
command! -nargs=0 NetrwToggle call explorer#toggle('netrw')

" vim-floaterm wrappers
command! -nargs=0 Lf packadd vim-floaterm | FloatermNew lf
command! -nargs=0 Ranger packadd vim-floaterm | FloatermNew ranger

if has('nvim')
    command! -nargs=0 LuaTreeToggle packadd nvim-tree.lua | LuaTreeToggle
endif

" Maps
nnoremap <silent> <Leader>n :call explorer#toggle(g:use_explorer)<CR>
nnoremap <silent>    <C-E>  :call explorer#toggle(g:use_explorer)<CR>
