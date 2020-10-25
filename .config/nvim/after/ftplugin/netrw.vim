noremap <buffer><silent><C-L> :TmuxNavigateRight<CR>
noremap <buffer> V :call <SID>open_to_right()<CR>
noremap <buffer> H :call <SID>open_below()<CR>

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
