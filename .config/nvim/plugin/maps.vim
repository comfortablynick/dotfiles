" ====================================================
" Filename:    plugin/maps.vim
" Description: General keymaps
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-03-05 11:04:51 CST
" ====================================================
let s:guard = 'g:loaded_plugin_maps' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" General {{{1
nnoremap U <C-r>
nnoremap qq :x<CR>
nnoremap qqq :q!<CR>
nnoremap <CR> :nohlsearch<CR><CR>

" Insert mode <Esc> maps
inoremap kj <Esc>`^
inoremap lkj <Esc>`^:w<CR>
inoremap ;lkj <Esc>`^:x<CR>

" Indent/outdent
vnoremap <Tab>   <Cmd>normal! >gv<CR>
vnoremap <S-Tab> <Cmd>normal! <gv<CR>

" Window navigation {{{1
" `CTRL+{h,j,k,l}` to navigate in normal mode
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" `ALT+{h,j,k,l}` to navigate windows from any mode
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Delete window to the left/below/above/to the right with d<C-h/j/k/l>.
nnoremap d<C-j> <C-w>j<C-w>c
nnoremap d<C-k> <C-w>k<C-w>c
nnoremap d<C-h> <C-w>h<C-w>c
nnoremap d<C-l> <C-w>l<C-w>c

" Tab navigation {{{1
nnoremap <silent> th :tabprev<CR>
nnoremap <silent> tl :tabnext<CR>
nnoremap <silent> tn :tabnew<CR>

" Override vim-impaired tagstack mapping
nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>

" Buffer navigation {{{1
" Ctrl + [n]ext/[p]revious buffer
nnoremap <silent> <C-n> :bnext<CR>
nnoremap <silent> <C-p> :bprevious<CR>

noremap <silent> <F5> :UndotreeToggle<CR>
