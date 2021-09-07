" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: open dotfiles quickly

let s:dot = {}

function s:dot.source() abort
    let l:fnames = [
        \ '~/.config/nvim/init.lua',
        \ '~/.vimrc',
        \ '~/env.toml',
        \ '~/.config/fish/config.fish',
        \ '~/.bashrc',
        \ '~/.zshrc',
        \ '~/.config/tmux/tmux.conf',
        \ ]
    return g:clap_enable_icon ? map(l:fnames, {_,v -> clap#icon#for(v) .. ' ' .. v}) : l:fnames
endfunction

let s:dot.on_move_async = { -> plugins#clap#file_preview_async() }
let s:dot.support_open_action = v:true

let s:dot.sink = {sel->plugins#clap#file_edit(sel)}

let g:clap#provider#dot# = s:dot
