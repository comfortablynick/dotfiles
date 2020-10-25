function! s:signify_hunk_next(count)
  let oldpos = getcurpos()
  call sy#jump#next_hunk(a:count)
  if getcurpos() == oldpos
    call sy#jump#prev_hunk(9999)
  endif
endfunction

function! s:signify_hunk_prev(count)
  let oldpos = getcurpos()
  call sy#jump#prev_hunk(a:count)
  if getcurpos() == oldpos
    call sy#jump#next_hunk(9999)
  endif
endfunction

" Preserve diff mode functionality for navigating changes
nnoremap <silent> <expr> <plug>(sy-hunk-next)
    \ &diff ? ']c' : ":\<c-u>call <SID>signify_hunk_next(v:count1)\<cr>"
nnoremap <silent> <expr> <plug>(sy-hunk-prev)
    \ &diff ? '[c' : ":\<c-u>call <SID>signify_hunk_prev(v:count1)\<cr>"

nmap ]c <plug>(sy-hunk-next)
nmap [c <plug>(sy-hunk-prev)
nnoremap <silent> ]C :call sy#jump#next_hunk(9999)<cr>
nnoremap <silent> [C :call sy#jump#next_prev(9999)<cr>
nnoremap <silent> <Leader>gu :SignifyHunkUndo<CR>
nnoremap <silent> gs :SignifyHunkDiff<CR>

let g:signify_sign_delete = '-'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change = '~'
