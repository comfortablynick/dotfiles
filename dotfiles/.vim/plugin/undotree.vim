if exists('g:loaded_plugin_undotree_zjjpnxtn') | finish | endif
let g:loaded_plugin_undotree_zjjpnxtn = 1

" Show tree on right + diff below
let g:undotree_WindowLayout = 4

" Maps
noremap <silent> <F5> :UndotreeToggle \| :UndotreeFocus<CR>
