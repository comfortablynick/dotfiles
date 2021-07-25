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

" Up/down
" For long, wrapped lines
nnoremap <silent>k gk
" For long, wrapped lines
nnoremap <silent>j gj

" For moving quickly up and down by skipping whitespace in current column
" TODO: moves inside folds; would be better to skip over them
nnoremap <Up>   <Cmd>call search('\%'..virtcol('.')..'v\S', 'bw')<CR>
nnoremap <Down> <Cmd>call search('\%'..virtcol('.')..'v\S', 'w')<CR>

" Use kj to escape insert mode
inoremap kj <Esc>`^

" Diff mode {{{2
nnoremap <expr> <Leader>gg &diff ? "<Cmd>diffget //1\<CR>" : ""
nnoremap <expr> <Leader>gh &diff ? "<Cmd>diffget //2\<CR>" : ""
nnoremap <expr> <Leader>gl &diff ? "<Cmd>diffget //3\<CR>" : ""

" Indent/outdent {{{2
vnoremap <Tab>   <Cmd>normal! >gv<CR>
vnoremap <S-Tab> <Cmd>normal! <gv<CR>

" Window navigation {{{1
" `CTRL+{h,j,k,l}` to navigate in normal mode {{{2
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-p> <C-w>p

" `ALT+{h,j,k,l}` resize vim/tmux panes in normal mode {{{2
" Note: vim has trouble with Meta/Alt key
if empty($TMUX)
    nnoremap <A-h> <Cmd>call window#vim_resize('h')<CR>
    nnoremap <A-j> <Cmd>call window#vim_resize('j')<CR>
    nnoremap <A-k> <Cmd>call window#vim_resize('k')<CR>
    nnoremap <A-l> <Cmd>call window#vim_resize('l')<CR>
else
    nnoremap <A-h> <Cmd>call window#tmux_aware_resize('h')<CR>
    nnoremap <A-j> <Cmd>call window#tmux_aware_resize('j')<CR>
    nnoremap <A-k> <Cmd>call window#tmux_aware_resize('k')<CR>
    nnoremap <A-l> <Cmd>call window#tmux_aware_resize('l')<CR>
endif


" Delete window to the left/below/above/to the right with d<C-h/j/k/l> {{{2
nnoremap d<C-j> <C-w>j<C-w>c
nnoremap d<C-k> <C-w>k<C-w>c
nnoremap d<C-h> <C-w>h<C-w>c
nnoremap d<C-l> <C-w>l<C-w>c

" Override vim-impaired tagstack mapping {{{2
nnoremap <silent> [t <Cmd>tabprevious<CR>
nnoremap <silent> ]t <Cmd>tabnext<CR>

" Buffer navigation {{{1
nnoremap <Tab>      <Cmd>bnext<CR>
nnoremap <S-Tab>    <Cmd>bprevious<CR>
nnoremap <Leader>w  <Cmd>update\|bwipeout<CR>
nnoremap <Leader>u  <Cmd>update\|Bdelete<CR>
nnoremap <Leader>q  <Cmd>Bdelete<CR>
nnoremap <Leader>x  <Cmd>call window#close_term()<CR>
nnoremap <Leader>xx <Cmd>BufOnly<CR>

" Quickfix
nnoremap cq <Cmd>call qf#toggle()<CR>

" Fold
nnoremap <Space> <Cmd>silent! exe 'normal! za'<CR>
nnoremap za zA

" Command line {{{1
" %% -> cwd
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" Format/indent {{{1
" Format buffer and restore cursor position
nnoremap <Leader>ff <Cmd>call buffer#restore_cursor_after('gggqG')<CR>
" Indent buffer and restore cursor position
nnoremap <Leader>fi <Cmd>call buffer#restore_cursor_after('gg=G')<CR>
