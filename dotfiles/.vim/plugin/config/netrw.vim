" ====================================================
" Filename: plugin/config/netrw.vim
" Author: Nick Murphy
" License: MIT License
" Last Change: 2019-11-22
" ====================================================
if exists('g:loaded_netrw_vim_config') | finish | endif
let g:loaded_netrw_vim_config = 1

"Toggles explorer buffer
function! s:toggle_v_explorer()
  if exists('t:expl_buf_num')
    let expl_win_num = bufwinnr(t:expl_buf_num)
    if expl_win_num != -1
      let cur_win_nr = winnr()
      exec expl_win_num . 'wincmd w'
      close
      exec cur_win_nr . 'wincmd w'
      unlet t:expl_buf_num
    else
      unlet t:expl_buf_num
    endif
  else
    exec '1wincmd w'
    Vexplore
    let t:expl_buf_num = bufnr('%')
  endif
endfunction

if get(g:, 'use_nerdtree', 0) == 0
    nnoremap <silent> <Leader>n :call <SID>toggle_v_explorer()<CR>
endif
