"   ____  _             _                 _
"  |  _ \| |_   _  __ _(_)_ __  _____   _(_)_ __ ___
"  | |_) | | | | |/ _` | | '_ \/ __\ \ / / | '_ ` _ \
"  |  __/| | |_| | (_| | | | | \__ \\ V /| | | | | | |
"  |_|   |_|\__,_|\__, |_|_| |_|___(_)_/ |_|_| |_| |_|
"                 |___/
"
" Common Vim/Neovim plugins

scriptencoding utf-8
" Helper functions/variables {{{1
" Vim-Plug Cond() {{{2
" Add conditions that aren't supported directly by vim-plug
function! Cond(cond, ...)
    let opts = get(a:000, 0, {})
    return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

let g:vim_exists = executable('vim')

" Completion filetypes {{{2
let g:completion_filetypes = {
    \ 'deoplete':
    \   [
    \       'fish',
    \       'vim',
    \       'python',
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
    \       'json',
    \       'go',
    \       'javascript',
    \       'typescript',
    \       'sh',
    \       'bash',
    \   ],
    \ }

" Plugin definitions {{{1
call plug#begin('~/.vim/plugged')

Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree',                 Cond(1, { 'on': 'NERDTreeToggle' })
Plug 'scrooloose/nerdcommenter'
Plug 'majutsushi/tagbar'
Plug 'junegunn/fzf',
    \ Cond(1, {
    \   'dir': '~/.fzf',
    \   'do': './install --bin --no-key-bindings --no-update-rc',
    \ })
Plug 'junegunn/fzf.vim'
Plug 'Shougo/echodoc'
Plug 'liuchengxu/vista.vim'
Plug 'tpope/vim-surround'
Plug 'chrisbra/Colorizer'
Plug 'skywind3000/asyncrun.vim'
Plug 'w0rp/ale'
Plug 'sbdchd/neoformat'
Plug 'vhdirk/vim-cmake',                    Cond(1, { 'for': ['cpp', 'c'] })
Plug 'christoomey/vim-tmux-navigator',      Cond(!empty($TMUX_PANE))
Plug 'christoomey/vim-tmux-runner',         Cond(!empty($TMUX_PANE))
    " \ { 'on':
    " \     [
    " \       'VtrSendCommandToRunner',
    " \       'VtrOpenRunner',
    " \       'VtrSendCommand',
    " \       'VtrSendFile',
    " \       'VtrKillRunner',
    " \       'VtrAttachToPane',
    " \     ]
    " \ })

" SYNTAX HIGHLIGHTING
Plug 'HerringtonDarkholme/yats'
Plug 'gabrielelana/vim-markdown'
Plug 'dag/vim-fish'
Plug 'cespare/vim-toml'
Plug 'bfrg/vim-cpp-modern',                 Cond(has('nvim'))

if g:vim_exists
    Plug 'jeaye/color_coded',
        \ Cond(!has('nvim'), {
        \   'for': [ 'c', 'cpp', 'c#' ],
        \   'do': 'rm -f CMakeCache.txt && cmake . && make && make install',
        \ })
endif

Plug 'junegunn/gv.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter',              Cond(0)
" Don't load if we're using coc (use coc-git instead)
autocmd vimrc FileType *
    \ if index(g:completion_filetypes['coc'], &filetype) < 0
    \ | call plug#load('vim-gitgutter')
    \ | endif

" COLOR THEMES
Plug 'arcticicestudio/nord-vim',            Cond(g:vim_base_color ==? 'nord')
Plug 'morhetz/gruvbox',                     Cond(g:vim_base_color ==? 'gruvbox')
Plug 'NLKNguyen/papercolor-theme',          Cond(g:vim_base_color ==? 'papercolor')
Plug 'nightsense/snow',                     Cond(g:vim_base_color ==? 'snow')

" CODE COMPLETION
Plug 'Shougo/neosnippet.vim',               Cond(has('nvim'))
Plug 'Shougo/neosnippet-snippets',          Cond(has('nvim'))
Plug 'honza/vim-snippets',                  Cond(has('nvim'))
Plug 'neoclide/coc.nvim',                   Cond(has('nvim'),
    \ {
    \   'do': 'yarn install --frozen-lockfile',
    \   'for': g:completion_filetypes['coc'],
    \ })
Plug 'Shougo/deoplete.nvim',                Cond(has('nvim'), { 'for': g:completion_filetypes['deoplete'] })
Plug 'Shougo/neco-vim',                     Cond(has('nvim'), { 'for': 'vim' })
Plug 'zchee/deoplete-jedi',                 Cond(has('nvim'), { 'for': 'python' })
Plug 'ponko2/deoplete-fish',                Cond(has('nvim'), { 'for': 'fish' })

if g:vim_exists
    Plug 'Valloric/YouCompleteMe',
        \ Cond(!has('nvim'),
        \ {
        \   'do': 'python3 ~/git/python/shell/vimsync.py -y',
        \   'for': g:completion_filetypes['ycm'],
        \ })
endif

" STATUSLINE
if g:vim_exists
    Plug 'vim-airline/vim-airline',         Cond(!has('nvim'))
    Plug 'vim-airline/vim-airline-themes',  Cond(!has('nvim'))
endif
let g:nvim_statusbar = 'eleline'
let g:use_lightline = get(g:, 'nvim_statusbar', '') ==# 'lightline'
let g:use_eleline =   get(g:, 'nvim_statusbar', '') ==# 'eleline'
let g:eleline_background = 234

Plug 'comfortablynick/eleline.vim',     Cond(has('nvim') && g:use_eleline)
Plug 'itchyny/lightline.vim',           Cond(has('nvim') && g:use_lightline)
Plug 'maximbaz/lightline-ale',          Cond(has('nvim') && g:use_lightline)
Plug 'mgee/lightline-bufferline',       Cond(has('nvim') && g:use_lightline)

call plug#end()
" vim:set fdl=1:
