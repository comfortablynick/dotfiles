" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: open dotfiles quickly

let s:dot = {}

function! s:dot.source()
    let l:dotfiles = [
        \ '$DOTDIR/.config/nvim/init.vim',
        \ '$DOTDIR/bashrc.sh',
        \ '$DOTDIR/.config/tmux/tmux.conf',
        \ ]
    let l:fnames = map(l:dotfiles, {_,v->fnamemodify(expand(v), ':~')})
    return map(l:fnames, {_,v->clap#icon#get(v).' '.v})
endfunction

let s:dot.on_move = {->plugin#clap#file_preview()}
let s:dot.sink = {sel->plugin#clap#file_edit(sel)}

let g:clap#provider#dot# = s:dot
