let g:use_explorer = 'rnvimr'
let g:use_explorer_coc = 'rnvimr'

" Commands
command! -nargs=0 NERDTreeToggle call plugins#lazy_run('NERDTreeToggle', 'nerdtree')
command! -nargs=0 TagbarToggle call plugins#tagbar#toggle()
command! -nargs=0 RnvimrToggle call plugins#lazy_run('RnvimrToggle', 'rnvimr')
command! -nargs=0 NetrwToggle call explorer#toggle('netrw')

" vim-floaterm wrappers
command! -nargs=* Lf call floaterm#run('new', <bang>0, '--width=0.6', '--height=0.6', 'lf')
command! -nargs=* Ranger 
    \ call floaterm#run('new', <bang>0, '--width=0.6', '--height=0.6', 'ranger')

" Maps
nnoremap <silent>    <C-E>  :call explorer#toggle(g:use_explorer)<CR>
nnoremap <silent> <Leader>n :call explorer#toggle(g:use_explorer)<CR>
