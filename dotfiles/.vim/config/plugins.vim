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
    \       'vim',
    \   ],
    \ }

" Plugin definitions {{{1
" Minpac Init {{{2
let minpac_path = expand('$HOME/.vim/pack/minpac/opt/minpac')
if empty(glob(minpac_path))
    echo 'Downloading Minpac'
    let clone = system('git clone https://github.com/k-takata/minpac.git ' . minpac_path)
endif

function! s:pack_init() abort
    packadd minpac
    if !exists('*minpac#init')
        echo "Minpac doesn't exist! Check download location"
        return
    endif
    command! -nargs=+ Pack call minpac#add(<args>)
    call minpac#init()

    " General Packages {{{2
    Pack 'k-takata/minpac',              {'type': 'opt'}
    Pack 'tpope/vim-scriptease',         {'type': 'opt'}
    Pack 'mhinz/vim-lookup',             {'type': 'opt'}
    Pack 'NLKNguyen/papercolor-theme',   {'type': 'opt'}
    Pack 'scrooloose/nerdtree',          {'type': 'opt'}
    Pack 'chrisbra/Colorizer',           {'type': 'opt'}
    Pack 'mhinz/vim-startify'
    Pack 'scrooloose/nerdcommenter'
    Pack 'tpope/vim-surround'
    Pack 'tpope/vim-projectionist'
    Pack 'liuchengxu/vista.vim'
    Pack 'w0rp/ale'
    Pack 'sbdchd/neoformat'
    Pack 'mbbill/undotree'
    Pack 'majutsushi/tagbar'
    " Pack 'Shougo/echodoc'
    Pack 'skywind3000/asyncrun.vim'
    Pack 'vhdirk/vim-cmake'
    Pack 'junegunn/fzf'
    Pack 'junegunn/fzf.vim'

    " Syntax highlighting {{{2
    Pack 'HerringtonDarkholme/yats'
    Pack 'gabrielelana/vim-markdown'
    Pack 'dag/vim-fish'
    Pack 'cespare/vim-toml'
    Pack 'chase/vim-ansible-yaml'

    " Git {{{2
    Pack 'airblade/vim-gitgutter',      {'type': 'opt'}
    Pack 'tpope/vim-fugitive',          {'type': 'opt'}
    Pack 'junegunn/gv.vim'

    " Nvim Only {{{2
    if has('nvim')
        Pack 'comfortablynick/eleline.vim'

        Pack 'Shougo/neosnippet.vim'
        Pack 'Shougo/neosnippet-snippets'
        Pack 'honza/vim-snippets'

        Pack 'bfrg/vim-cpp-modern'
        Pack 'neoclide/coc.nvim',
            \ {
            \   'type': 'opt',
            \   'do': '!yarn install --frozen-lockfile'
            \ }

        " Deoplete
        Pack 'Shougo/deoplete.nvim',    {'type': 'opt'}
        " Pack 'tweekmonster/deoplete-clang2'
        " Pack 'Shougo/neco-vim',
        Pack 'zchee/deoplete-jedi'
        Pack 'ponko2/deoplete-fish'

        Pack 'christoomey/vim-tmux-navigator'
        Pack 'christoomey/vim-tmux-runner'
    endif
endfunction

" Pack autocmds {{{3
" Don't load if we're using coc (use coc-git instead)
autocmd vimrc FileType *
    \ if index(g:completion_filetypes['coc'], &filetype) < 0
    \ | packadd vim-gitgutter
    \ | packadd vim-fugitive
    \ | endif

" Pack commands {{{3
" Define commands for updating/cleaning the plugins.
command! PackUpdate call <SID>pack_init() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call <SID>pack_init() | call minpac#clean()
command! PackStatus call <SID>pack_init() | call minpac#status()

let g:eleline_background = 234

" Vim Plug Config {{{2
" BEGIN {{{3
" call plug#begin('~/.vim/plugged')                               " Plugin Manager

" Editor features {{{3
" Plug 'mhinz/vim-startify'
" Plug 'scrooloose/nerdtree',             Cond(1, { 'on': 'NERDTreeToggle' })
" Plug 'scrooloose/nerdcommenter'
" Plug 'mbbill/undotree',                 Cond(1, { 'on': 'UndotreeToggle' })
" Plug 'majutsushi/tagbar'
" Plug 'junegunn/fzf',
"     \ Cond(1, {
"     \   'dir': '~/.fzf',
"     \   'do': './install --bin --no-key-bindings --no-update-rc',
"     \ })
" Plug 'junegunn/fzf.vim'
" Plug 'ryanoasis/vim-devicons',          Cond(g:LL_nf)
" Plug 'Shougo/echodoc'
" Plug 'liuchengxu/vista.vim'
" Plug 'tpope/vim-surround'
" Plug 'chrisbra/Colorizer'

" Linting {{{3
" Plug 'w0rp/ale'

" Formatting {{{3
" Plug 'sbdchd/neoformat'

" Syntax highlighting {{{3
" Plug 'HerringtonDarkholme/yats'
" Plug 'gabrielelana/vim-markdown'
" Plug 'dag/vim-fish'
" Plug 'cespare/vim-toml'
" Plug 'bfrg/vim-cpp-modern',             Cond(has('nvim'))
" Plug 'chase/vim-ansible-yaml'

" Clang (compiled, vim only)
" if g:vim_exists
"     Plug 'jeaye/color_coded',
"         \ Cond(!has('nvim'), {
"         \   'for': [ 'c', 'cpp', 'c#' ],
"         \   'do': 'rm -f CMakeCache.txt && cmake . && make && make install',
"         \ })
" endif

" Git {{{3
" Plug 'airblade/vim-gitgutter',          Cond(0)
"
" Plug 'tpope/vim-fugitive',              Cond(0)
" " Don't load if we're using coc (use coc-git instead)
" autocmd vimrc FileType *
"     \ if index(g:completion_filetypes['coc'], &filetype) != 1
"     \ | call plug#load('vim-gitgutter')
"     \ | call plug#load('vim-fugitive')
"     \ | endif
"
" Plug 'junegunn/gv.vim'

" Color themes {{{3
" Conditionally load themes based on env var
" Plug 'arcticicestudio/nord-vim',        Cond(g:vim_base_color ==? 'nord')
" Plug 'morhetz/gruvbox',                 Cond(g:vim_base_color ==? 'gruvbox')
" Plug 'NLKNguyen/papercolor-theme',      Cond(g:vim_base_color ==? 'papercolor')
" Plug 'nightsense/snow',                 Cond(g:vim_base_color ==? 'snow')

" Terminal/Code Execution {{{3
" Plug 'skywind3000/asyncrun.vim'

" Snippets {{{3
" Plug 'Shougo/neosnippet.vim',           Cond(has('nvim'))
" Plug 'Shougo/neosnippet-snippets',      Cond(has('nvim'))
" Plug 'honza/vim-snippets',              Cond(has('nvim'))

" Building {{{3
" Plug 'vhdirk/vim-cmake',                Cond(1, { 'for': ['cpp', 'c'] })

" Code completion/Language server {{{3
" Coc {{{4
" Exclude completion on deoplete file types, so we can still use other features
" autocmd vimrc FileType *
"     \ if index(g:completion_filetypes['coc'], &filetype) < 0
"     \ | let b:coc_suggest_disable = 1

" Plug 'neoclide/coc.nvim',
"     \ Cond(has('nvim'),
"     \ {
"     \   'do': 'yarn install --frozen-lockfile',
"     \   'for': g:completion_filetypes['coc'],
"     \ })

" Deoplete {{{4
" Plug 'Shougo/deoplete.nvim',
"     \ Cond(has('nvim'),
"     \ {
"     \   'for': g:completion_filetypes['deoplete'],
"     \ })

" YouCompleteMe {{{4
" if g:vim_exists
"     Plug 'Valloric/YouCompleteMe',
"         \ Cond(!has('nvim'),
"         \ {
"         \   'do': 'python3 ~/git/python/shell/vimsync.py -y',
"         \   'for': g:completion_filetypes['ycm'],
"         \ })
" endif

" C {{{4
" Plug 'tweekmonster/deoplete-clang2',
"     \ Cond(has('nvim'))

" Vim {{{4
" Plug 'Shougo/neco-vim',
"     \ Cond(has('nvim'),
"     \ {
"     \   'for': 'vim'
"     \ })

" Python (Jedi) {{{4
" Plug 'zchee/deoplete-jedi',
"     \ Cond(has('nvim'),
"     \ {
"     \   'for': 'python',
"     \ })

" Fish {{{4
" Plug 'ponko2/deoplete-fish',
"     \ Cond(has('nvim'),
"     \ {
"     \   'for': 'fish',
"     \ })

" Go {{{4
" Plug 'zchee/deoplete-go',
"     \ Cond(has('nvim'),
"     \ {
"     \   'do': 'make',
"     \ })

" Plug 'mdempsky/gocode',
"     \ Cond(has('nvim'),
"     \ {
"     \   'rtp': 'vim',
"     \   'do': '~/.vim/plugged/gocode/vim/symlink.sh'
"     \ })

" Status line {{{4
" Vim (Airline)
" if g:vim_exists
"     Plug 'vim-airline/vim-airline',         Cond(!has('nvim'))
"     Plug 'vim-airline/vim-airline-themes',  Cond(!has('nvim'))
" endif

" Neovim (Lightline/Eleline)
" let g:nvim_statusbar = 'eleline'
" let g:use_lightline = get(g:, 'nvim_statusbar', '') ==# 'lightline'
" let g:use_eleline =   get(g:, 'nvim_statusbar', '') ==# 'eleline'
" let g:eleline_background = 234
"
" let g:eleline_local_path = '$HOME/git/eleline.vim'
" if !empty(glob(expand(g:eleline_local_path)))
"     Plug g:eleline_local_path,          Cond(has('nvim') && g:use_eleline)
" else
"     Plug 'comfortablynick/eleline.vim', Cond(has('nvim') && g:use_eleline)
" endif
" Plug 'itchyny/lightline.vim',           Cond(has('nvim') && g:use_lightline)
" Plug 'maximbaz/lightline-ale',          Cond(has('nvim') && g:use_lightline)
" Plug 'mgee/lightline-bufferline',       Cond(has('nvim') && g:use_lightline)
"
" Tmux {{{4
" Plug 'christoomey/vim-tmux-navigator',  Cond(!empty($TMUX_PANE))
" Plug 'christoomey/vim-tmux-runner',
"     \ Cond(!empty($TMUX_PANE),
"     \ {
"     \   'on':
"     \     [
"     \       'VtrSendCommandToRunner',
"     \       'VtrOpenRunner',
"     \       'VtrSendCommand',
"     \       'VtrSendFile',
"     \       'VtrKillRunner',
"     \       'VtrAttachToPane',
"     \     ]
"     \ })

" END {{{3
" call plug#end()

" Plugin configuration {{{1
" Echodoc {{{2
" TODO: Only execute for python/ts/js?
" let g:echodoc#enable_at_startup = 1
" let g:ecodoc#type = 'echo'                   " virtual: virtualtext; echo: use command line echo area

" Neosnippet {{{2
if exists('g:loaded_neosnippet')
    let g:neosnippet#enable_completed_snippet = 1
    autocmd vimrc CompleteDone * call neosnippet#complete_done()
endif

" Airline {{{2
" let g:airline_extensions = [
"     \ 'tabline',
"     \ 'ale',
"     \ 'branch',
"     \ 'hunks',
"     \ 'wordcount',
"     \ 'virtualenv',
"     \ 'tagbar',
"     \ ]
" let g:airline#extensions#default#section_truncate_width = {
"     \ 'b': 79,
"     \ 'x': 40,
"     \ 'y': 48,
"     \ 'z': 45,
"     \ 'warning': 80,
"     \ 'error': 80,
"     \ }
" let g:airline_powerline_fonts = 1
" let g:airline_detect_spelllang = 0
" let g:airline_highlighting_cache = 1
"
" " Airline Tabline
" let g:airline#extensions#tabline#show_buffers = 0
" let g:airline#extensions#tabline#show_close_button = 0

" YouCompleteMe {{{2
" let g:ycm_filetype_blacklist = {
"     \ 'gitcommit': 1,
"     \ 'tagbar': 1,
"     \ 'qf': 1,
"     \ 'notes': 1,
"     \ 'markdown': 1,
"     \ 'unite': 1,
"     \ 'text': 1,
"     \ 'vimwiki': 1,
"     \ 'pandoc': 1,
"     \ 'infolog': 1,
"     \ 'mail': 1
"     \}
" let g:ycm_filetype_specific_completion_to_disable = {
"     \ 'gitcommit': 1
"     \}
" let g:ycm_autoclose_preview_window_after_completion = 1         " Ditch preview window after completion

" Syntax highlighting {{{2
" C/C++
" Disable function highlighting (affects both C and C++ files)
let g:cpp_no_function_highlight = 1

" Put all standard C and C++ keywords under Vim's highlight group `Statement`
" (affects both C and C++ files)
let g:cpp_simple_highlight = 1

" Enable highlighting of named requirements (C++20 library concepts)
let g:cpp_named_requirements_highlight = 1

" vim:set fdl=1:
