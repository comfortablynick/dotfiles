" Plugins for Vim only

set rtp+=/usr/local/lib/python3.7/site-packages/powerline/bindings/vim
Plug 'itchyny/lightline.vim'                                    " Statusline
Plug 'maximbaz/lightline-ale'                                   " ALE status in Lightline
Plug 'Valloric/YouCompleteMe',                                  " Code completion (compiled on install/update)
    \ {
    \   'do': '~/git/python/shell/vimsync.py'
    \ }
" Plug 'Shougo/deoplete.nvim'                                     " Code completion
" Plug 'roxma/nvim-yarp'                                          " Required by deoplete
" Plug 'roxma/vim-hug-neovim-rpc'                                 " Required by deoplete

" PLUGIN CONFIGURATION ==========================

" YouCompleteMe
let g:ycm_filetype_blacklist = {
      \ 'gitcommit': 1,
      \ 'tagbar': 1,
      \ 'qf': 1,
      \ 'notes': 1,
      \ 'markdown': 1,
      \ 'unite': 1,
      \ 'text': 1,
      \ 'vimwiki': 1,
      \ 'pandoc': 1,
      \ 'infolog': 1,
      \ 'mail': 1
      \}
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1
      \}
let g:ycm_autoclose_preview_window_after_completion = 1         " Ditch preview window after completion
