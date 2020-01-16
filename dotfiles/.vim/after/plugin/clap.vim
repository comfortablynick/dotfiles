" ====================================================
" Filename:    after/plugin/clap.vim
" Description: Clap.vim plugin config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-16 16:59:46 CST
" ====================================================
if exists('g:loaded_after_plugin_clap_2dn7l3mw') || !exists(':Clap')
    finish
endif
let g:loaded_after_plugin_clap_2dn7l3mw = 1

" General settings
let g:clap_multi_selection_warning_silent = 1
let g:clap_enable_icon = get(g:, 'LL_nf', 0)

" Providers
let g:clap_provider_alias = {
    \ 'hist': 'command_history',
    \ 'maps': 'maps',
    \ }

let g:clap#provider#maps# = config#clap#maps
let g:clap#provider#scriptnames# = config#clap#scriptnames

" `:Clap dot` to open some dotfiles quickly.
let g:clap_provider_dot = {
    \ 'source': [
    \     '~/dotfiles/dotfiles/.config/nvim/init.vim',
    \     '~/dotfiles/dotfiles/bashrc.sh',
    \     '~/dotfiles/dotfiles/tmux.conf',
    \ ],
    \ 'sink': 'e',
    \ }

" Maps
nnoremap <silent> <Leader>t :Clap tags<CR>
nnoremap <silent> <Leader>h :Clap command_history<CR>
