" ====================================================
" Filename:    after/plugin/clap.vim
" Description: Clap.vim plugin config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-13 16:16:53 CST
" ====================================================
if exists('g:loaded_after_plugin_clap_2dn7l3mw') || !exists(':Clap')
    finish
endif
let g:loaded_after_plugin_clap_2dn7l3mw = 1

let g:clap_enable_icon = get(g:, 'LL_nf', 0) " Does this work?
let g:clap_provider_alias = {'hist': 'command_history'}

" `:Clap dot` to open some dotfiles quickly.
let g:clap_provider_dot = {
    \ 'source': [
    \     '~/dotfiles/dotfiles/.config/nvim/init.vim',
    \     '~/dotfiles/dotfiles/bashrc.sh',
    \     '~/dotfiles/dotfiles/tmux.conf',
    \ ],
    \ 'sink': 'e',
    \ }

let g:clap_multi_selection_warning_silent = 1
