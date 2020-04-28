" ====================================================
" Filename:    plugin/maps.vim
" Description: General keymaps
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_plugin_maps' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" General {{{1
nnoremap U <C-r>
nnoremap qq :x<CR>
nnoremap qqq :q!<CR>
nnoremap <CR> :nohlsearch<CR><CR>
tnoremap <buffer><silent> <Esc> <C-\><C-n><CR>:bw!<CR>

" Insert mode <Esc> maps {{{2
inoremap kj <Esc>`^
inoremap lkj <Esc>`^:w<CR>
inoremap ;lkj <Esc>`^:x<CR>

" Indent/outdent {{{2
vnoremap <Tab>   <Cmd>normal! >gv<CR>
vnoremap <S-Tab> <Cmd>normal! <gv<CR>

" Window navigation {{{1
" `CTRL+{h,j,k,l}` to navigate in normal mode {{{2
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" `ALT+{h,j,k,l}` to navigate windows from other modes {{{2
" Note: vim has trouble with Meta/Alt key
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l

" Delete window to the left/below/above/to the right with d<C-h/j/k/l> {{{2
nnoremap d<C-j> <C-w>j<C-w>c
nnoremap d<C-k> <C-w>k<C-w>c
nnoremap d<C-h> <C-w>h<C-w>c
nnoremap d<C-l> <C-w>l<C-w>c

" Tab navigation {{{1
nnoremap <silent> th :tabprev<CR>
nnoremap <silent> tl :tabnext<CR>
nnoremap <silent> tn :tabnew<CR>

" Override vim-impaired tagstack mapping {{{2
nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>

" Buffer navigation {{{1
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
nnoremap <silent> <Leader>q :bd<CR>

" Fzy {{{1
" Use fd/find to select file and edit {{{2
let g:findprg = executable('fd') ? 'fd -t f -HL' : 'find . -type f -L'
nnoremap <silent> <Leader>e
    \ :call fzy#command(g:findprg, ':e')<CR>

" vim:fdl=1:
