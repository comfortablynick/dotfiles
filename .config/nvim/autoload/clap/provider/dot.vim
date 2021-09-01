" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: open dotfiles quickly

let s:dot = {}

function s:dot.source() abort
    let l:fnames = [
        \ '~/.config/nvim/init.lua',
        \ '~/.bashrc',
        \ '~/.config/tmux/tmux.conf',
        \ ]
    if g:clap_enable_icon
        return map(l:fnames, {_,v -> clap#icon#for(v) .. ' ' .. v})
    else
        return l:fnames
    endif
endfunction

function s:into_filename(sel) abort
  if g:clap_enable_icon && clap#maple#is_available()
    return a:sel[4:]
  else
    return a:sel
  endif
endfunction

" let s:dot.on_move = {->plugins#clap#file_preview()}
function s:dot.on_move() abort
    return clap#preview#file(s:into_filename(g:clap.display.getcurline()))
endfunction

let s:dot.sink = {sel->plugins#clap#file_edit(sel)}

let g:clap#provider#dot# = s:dot
