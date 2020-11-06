noremap  <silent><buffer> <C-L> :TmuxNavigateRight<CR>
nnoremap <silent><buffer> V     :call <SID>open_to_right()<CR>
nnoremap <silent><buffer> H     :call <SID>open_below()<CR>
nnoremap <silent><buffer> q     :call editor#quick_close_buffer()<CR>

function! s:open_to_right()
    normal! v
    let l:path=expand('%:p')
    q!
    execute 'belowright vnew' l:path
    normal! <C-L>
endfunction

function! s:open_below()
    normal! v
    let l:path=expand('%:p')
    q!
    execute 'belowright new' l:path
    normal! <C-L>
endfunction
