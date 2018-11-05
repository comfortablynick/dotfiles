" Plugins for Vim only

set rtp+=/usr/local/lib/python3.7/site-packages/powerline/bindings/vim
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }         " Code completion (compiled)
" Plug 'Shougo/deoplete.nvim'                                     " Code completion
" Plug 'roxma/nvim-yarp'                                          " Required by deoplete
" Plug 'roxma/vim-hug-neovim-rpc'                                 " Required by deoplete

" YCM settings
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
