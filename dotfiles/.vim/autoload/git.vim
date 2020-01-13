" ====================================================
" Filename:    autoload/git.vim
" Description: Git-related functions
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-12 14:36:06 CST
" ====================================================

" Wrap around buffer when navigating hunks
function! git#prev_hunk(count) abort
  for i in range(1, a:count)
    let line = line('.')
    silent GitGutterPrevHunk
    if line('.') == line
      normal! G
      silent GitGutterPrevHunk
    endif
  endfor
endfunction

function! git#next_hunk(count) abort
  for i in range(1, a:count)
    let line = line('.')
    silent GitGutterNextHunk
    if line('.') == line
      normal! 1G
      silent GitGutterNextHunk
    endif
  endfor
endfunction
