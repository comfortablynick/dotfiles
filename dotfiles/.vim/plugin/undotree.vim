if exists('g:loaded_plugin_undotree_zjjpnxtn') | finish | endif
let g:loaded_plugin_undotree_zjjpnxtn = 1

" Show tree on right + diff below
let g:undotree_WindowLayout = 4

" Load and toggle undotree when called
function s:toggle_undotree() abort
    if !exists('g:loaded_undotree')
        packadd undotree
    endif
    call undotree#UndotreeToggle()
    call undotree#UndotreeFocus()
endfunction

" Maps
noremap <silent> <F5> :call <SID>toggle_undotree()<CR>
