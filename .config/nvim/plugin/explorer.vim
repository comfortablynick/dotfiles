" ====================================================
" Filename:    plugin/explorer.vim
" Description: Handle project file explorer plugin settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-03-17 20:40:46 CDT
" ====================================================
let s:guard = 'g:loaded_plugin_explorer' | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:use_explorer = 'netrw'             " netrw/nerdtree/defx/coc-explorer (set from coc config)
let g:use_explorer_coc = 'coc-explorer' " use with coc.nvim

" Commands
command! -nargs=0 LuaTreeToggle packadd nvim-tree.lua | LuaTreeToggle
command! -nargs=0 NERDTreeToggle packadd nerdtree | NERDTreeToggle
command! -nargs=0 TagbarToggle call plugins#tagbar#toggle()
command! -nargs=0 RnvimrToggle packadd rnvimr | RnvimrToggle
command! -nargs=0 LfToggle packadd floatLf-nvim | LfToggle
command! -nargs=0 LfToggleCurrentBuf packadd floatLf-nvim | LfToggleCurrentBuf
command! -nargs=0 DefxToggle call explorer#toggle('defx')
command! -nargs=0 NetrwToggle call explorer#toggle('netrw')

" Maps
nnoremap <silent> <Leader>n :call explorer#toggle(g:use_explorer)<CR>
nnoremap <silent>    <C-E>  :call explorer#toggle(g:use_explorer)<CR>
