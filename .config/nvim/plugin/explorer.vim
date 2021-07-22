let g:use_explorer = 'rnvimr'
let g:use_explorer_coc = 'rnvimr'

" Commands
command! -nargs=0 NERDTreeToggle call plugins#lazy_run('NERDTreeToggle', 'nerdtree')
command! -nargs=0 NetrwToggle    call explorer#toggle('netrw')

function s:lf_current_file() abort
    let l:file = expand('%:p')
    let l:cmd = 'FloatermNew lf'
    if filereadable(l:file)
        let l:cmd ..= printf(' -command "select %s"', l:file)
    endif
    exe l:cmd
endfunction

" vim-floaterm wrappers
command! Lf     call s:lf_current_file()
command! Ranger FloatermNew ranger

" Maps
nnoremap <silent>    <C-E>  :call explorer#toggle(g:use_explorer)<CR>
nnoremap <silent> <Leader>n :call explorer#toggle(g:use_explorer)<CR>
