scriptencoding utf-8

function s:signify_hunk_next(count)
  let l:oldpos = getcurpos()
  call sy#jump#next_hunk(a:count)
  if getcurpos() == l:oldpos
    call sy#jump#prev_hunk(9999)
  endif
endfunction

function s:signify_hunk_prev(count)
  let l:oldpos = getcurpos()
  call sy#jump#prev_hunk(a:count)
  if getcurpos() == l:oldpos
    call sy#jump#next_hunk(9999)
  endif
endfunction

" Preserve diff mode functionality for navigating changes
nnoremap <silent> <expr> <Plug>(sy-hunk-next)
    \ &diff ? ']c' : ":\<c-u>call <SID>signify_hunk_next(v:count1)\<cr>"
nnoremap <silent> <expr> <Plug>(sy-hunk-prev)
    \ &diff ? '[c' : ":\<c-u>call <SID>signify_hunk_prev(v:count1)\<cr>"

nmap     ]c <Plug>(sy-hunk-next)
nmap     [c <Plug>(sy-hunk-prev)
nnoremap ]C <Cmd>call sy#jump#next_hunk(9999)<CR>
nnoremap [C <Cmd>call sy#jump#next_prev(9999)<CR>

nnoremap <Leader>gu <Cmd>SignifyHunkUndo<CR>
nnoremap gs         <Cmd>SignifyHunkDiff<CR>

let g:signify_sign_delete = '-'
let g:signify_sign_delete_first_line = '‾'
let g:signify_sign_change = '~'
