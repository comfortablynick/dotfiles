"   ____  _             _                 _
"  |  _ \| |_   _  __ _(_)_ __  _____   _(_)_ __ ___
"  | |_) | | | | |/ _` | | '_ \/ __\ \ / / | '_ ` _ \
"  |  __/| | |_| | (_| | | | | \__ \\ V /| | | | | | |
"  |_|   |_|\__,_|\__, |_|_| |_|___(_)_/ |_|_| |_| |_|
"                 |___/
"
" Common Vim/Neovim plugins

" Helper functions/variables {{{1
" TODO: move everything but `packadd`s to canonical path
" Completion filetypes {{{2
let g:completion_filetypes = {
    \ 'deoplete':
    \   [
    \       'fish',
    \   ],
    \ 'ycm':
    \   [
    \       'python',
    \       'javascript',
    \       'typescript',
    \       'cpp',
    \       'c',
    \       'go',
    \       'rust',
    \   ],
    \ 'coc':
    \   [
    \       'rust',
    \       'cpp',
    \       'c',
    \       'typescript',
    \       'javascript',
    \       'json',
    \       'lua',
    \       'go',
    \       'python',
    \       'sh',
    \       'bash',
    \       'vim',
    \       'yaml',
    \       'snippets',
    \   ],
    \ 'mucomplete':
    \   [
    \       'pro',
    \       'mail',
    \       'txt',
    \       'ini',
    \       'muttrc',
    \   ],
    \ 'tabnine':
    \   [
    \       'markdown',
    \       'toml',
    \   ],
    \  'nvim-lsp':
    \   [],
    \ }

" Exclude from default completion
let g:nocompletion_filetypes = [
    \ 'nerdtree',
    \ ]


" FileType Autocmds {{{2
" Don't load if we're using coc (use coc-git instead)
autocmd vimrc FileType *
    \ if index(g:completion_filetypes['coc'], &filetype) < 0
    \ | packadd vim-gitgutter
    \ | endif

autocmd vimrc FileType *
    \ if index(g:completion_filetypes['tabnine'], &filetype) >= 0
    \ | packadd tabnine-vim
    \ | endif

autocmd vimrc FileType *
    \ if index(g:completion_filetypes['deoplete'], &filetype) >= 0
    \ | packadd deoplete.nvim
    \ | packadd deoplete-jedi
    \ | packadd deoplete-fish
    \ | endif

" Load packages {{{1
packadd! lightline.vim
packadd! fzf
packadd! fzf.vim
packadd! ale
packadd! neoformat
packadd! undotree
" TODO: replace with something else like async.vim?
" packadd! asyncrun.vim
packadd! vim-sneak
packadd! vim-fugitive
packadd! vim-surround
packadd! vim-localvimrc
packadd! vim-clap

" Snippets
" Load ultisnips
packadd! vim-snippets

" Syntax
packadd! vim-cpp-modern
packadd! vim-markdown
packadd! ansible-vim
packadd! semshi

" Tmux
packadd! vim-tmux-runner
packadd! vim-tmux-navigator

" vim:set fdm=marker fdl=1:
