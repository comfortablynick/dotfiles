" General {{{1
nnoremap U <C-r>
nnoremap qq :x<CR>
nnoremap qqq :q!<CR>
nnoremap QQ ZQ
nnoremap Y y$

" Remap ; to :
nnoremap ; :
xnoremap ; :
onoremap ; :
nnoremap g: g;
nnoremap @; @:
nnoremap q; q:
xnoremap q; q:

" Run the last command
nnoremap <Leader><Leader>c :<Up>

" Clears hlsearch after doing a search, otherwise <CR>
nnoremap <expr> <CR> {-> v:hlsearch ? ":nohlsearch\<CR>" : "\<CR>"}()
tnoremap <buffer><silent> <Esc> <C-\><C-n><CR>:bw!<CR>

" Enhanced up/down movement {j,k} {{{2
" For long, wrapped lines
nnoremap <silent>k gk
" For long, wrapped lines
nnoremap <silent>j gj

" For moving quickly up and down
" https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/plugin/keymaps.vim
" Goes to the first line above/below that isn't whitespace
" Thanks to: http://vi.stackexchange.com/a/213
nnoremap <silent><Up>   :let _=&lazyredraw<CR>:set lazyredraw<CR>?\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>
nnoremap <silent><Down> :let _=&lazyredraw<CR>:set lazyredraw<CR>/\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>

" Insert mode <Esc> maps {{{2
inoremap kj   <Esc>`^
inoremap lkj  <Esc>`^:w<CR>
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

" Override vim-impaired tagstack mapping {{{2
nnoremap <silent> [t :tabprevious<CR>
nnoremap <silent> ]t :tabnext<CR>

" Buffer navigation {{{1
nnoremap <silent> <Tab>      :bnext<CR>
nnoremap <silent> <S-Tab>    :bprevious<CR>
nnoremap <silent> <Leader>w  :write\|bwipeout<CR>
nnoremap <silent> <Leader>q  :Bdelete<CR>
nnoremap <silent> <Leader>xx :BufOnly<CR>

" Quickfix
nnoremap <silent> cq :call quickfix#toggle()<CR>

" Command line {{{1
" %% -> cwd
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" Format/indent {{{1
" Format buffer and restore cursor position
nnoremap <silent> <Leader>ff :call buffer#restore_cursor_after('gggqG')<CR>
" Indent buffer and restore cursor position
nnoremap <silent> <Leader>fi :call buffer#restore_cursor_after('gg=G')<CR>

" vim:fdl=1:
