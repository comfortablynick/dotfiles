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
" " let s:dot.on_move_async = { -> clap#client#call_preview_file(v:null) }

" function s:dot.on_move() abort
"     return clap#preview#file(s:into_filename(g:clap.display.getcurline()))
" endfunction

" function s:dot.on_move_async() abort
"     let l:fpath = s:into_filename(g:clap.display.getcurline())
"     return clap#client#call_preview_file(v:null)
" endfunction
let s:dot.on_move = function('clap#provider#files#on_move_impl')
let s:dot.on_move_async = function('clap#impl#on_move#async')
let s:dot.support_open_action = v:true

let s:dot.sink = {sel->plugins#clap#file_edit(sel)}

let g:clap#provider#dot# = s:dot
