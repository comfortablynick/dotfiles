"   ____  _             _                 _
"  |  _ \| |_   _  __ _(_)_ __  _____   _(_)_ __ ___
"  | |_) | | | | |/ _` | | '_ \/ __\ \ / / | '_ ` _ \
"  |  __/| | |_| | (_| | | | | \__ \\ V /| | | | | | |
"  |_|   |_|\__,_|\__, |_|_| |_|___(_)_/ |_|_| |_| |_|
"                 |___/
"
" Common Vim/Neovim plugins

" " Helper functions/variables {{{1
" " TODO: move everything but `packadd`s to canonical path
" " Completion filetypes {{{2
" let g:completion_filetypes = {
"     \ 'deoplete':
"     \   [
"     \       'fish',
"     \   ],
"     \ 'ycm':
"     \   [
"     \       'python',
"     \       'javascript',
"     \       'typescript',
"     \       'cpp',
"     \       'c',
"     \       'go',
"     \       'rust',
"     \   ],
"     \ 'coc':
"     \   [
"     \       'rust',
"     \       'cpp',
"     \       'c',
"     \       'typescript',
"     \       'javascript',
"     \       'json',
"     \       'lua',
"     \       'go',
"     \       'python',
"     \       'sh',
"     \       'bash',
"     \       'vim',
"     \       'yaml',
"     \       'snippets',
"     \   ],
"     \ 'mucomplete':
"     \   [
"     \       'pro',
"     \       'mail',
"     \       'txt',
"     \       'ini',
"     \       'muttrc',
"     \   ],
"     \ 'tabnine':
"     \   [
"     \       'markdown',
"     \       'toml',
"     \   ],
"     \  'nvim-lsp':
"     \   [],
"     \ }
" " Exclude from default completion
" let g:nocompletion_filetypes = [
"     \ 'nerdtree',
"     \ ]

" Load packages {{{1
silent! packadd! lightline.vim
silent! packadd! fzf
silent! packadd! fzf.vim
silent! packadd! ale
silent! packadd! neoformat
silent! packadd! undotree
silent! packadd! vim-sneak
silent! packadd! vim-fugitive
silent! packadd! vim-surround
silent! packadd! vim-localvimrc
silent! packadd! vim-clap

" Snippets
silent! packadd! vim-snippets

" Syntax
silent! packadd! vim-cpp-modern
silent! packadd! vim-markdown
silent! packadd! ansible-vim
silent! packadd! semshi

" Tmux
silent! packadd! vim-tmux-navigator

" vim:set fdm=marker fdl=1:
