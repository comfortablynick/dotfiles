noremap  <silent><buffer> <C-L> :TmuxNavigateRight<CR>
nnoremap <silent><buffer> V     :call <SID>open_file('belowright vnew')<CR>
nnoremap <silent><buffer> H     :call <SID>open_file('belowright new')<CR>
nnoremap <silent><buffer> q     :call buffer#quick_close()<CR>

" TODO: doesn't quite work right; interferes with Dirvish?
function s:open_file(open_cmd)
    normal! v
    let l:path = expand('%:p')
    quit
    execute a:open_cmd l:path
    normal! <C-L>
endfunction
