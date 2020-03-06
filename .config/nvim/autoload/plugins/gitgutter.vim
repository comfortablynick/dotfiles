if exists('g:loaded_autoload_plugins_gitgutter') | finish | endif
let g:loaded_autoload_plugins_gitgutter = 1

function! plugins#gitgutter#pre() abort
    let g:gitgutter_map_keys = 0
endfunction

function! plugins#gitgutter#post() abort
    command! -count=1 GitNextHunk call plugins#gitgutter#next_hunk(<count>)
    command! -count=1 GitPrevHunk call plugins#gitgutter#prev_hunk(<count>)

    nnoremap <silent> ]g :GitNextHunk<CR>
    nnoremap <silent> [g :GitPrevHunk<CR>
    nmap ghs <Plug>(GitGutterStageHunk)
    nmap ghu <Plug>(GitGutterUndoHunk)
    nmap gs <Plug>(GitGutterPreviewHunk)
endfunction

" Wrap around buffer when navigating hunks
function! plugins#gitgutter#prev_hunk(count) abort
  for l:i in range(1, a:count)
    let l:line = line('.')
    silent GitGutterPrevHunk
    if line('.') == l:line
      normal! G
      silent GitGutterPrevHunk
    endif
  endfor
endfunction

function! plugins#gitgutter#next_hunk(count) abort
  for l:i in range(1, a:count)
    let l:line = line('.')
    silent GitGutterNextHunk
    if line('.') == l:line
      normal! 1G
      silent GitGutterNextHunk
    endif
  endfor
endfunction
