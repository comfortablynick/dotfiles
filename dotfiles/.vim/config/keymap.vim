" KEYMAPPING ====================================

" Global {{{
" `<comma>` :: <Leader> (g:mapleader)
let g:mapleader = ','

" `Ctrl+n` :: toggle NERDTree
noremap <silent> <C-n> :NERDTreeToggle<CR>

" <Space> :: toggle folds
noremap <Space> za

" za :: Open all folds
noremap za zA

" `F2` :: Run Neoformat
noremap <silent> <F2> :Neoformat<CR>

" `F5` :: toggle UndoTree
noremap <silent> <F5> :UndotreeToggle \| :UndotreeFocus<CR>

" `F8` :: toggle TagBar
noremap <silent> <F8> :TagbarToggle<CR>

" F10 to toggle quickfix window for asyncrun
noremap <silent> <F10> :call asyncrun#quickfix_toggle(6)<CR>
" }}}
" Normal mode {{{
" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Tagbar
nnoremap <Leader>t :TagbarToggle<CR>
" }}}
" Insert mode {{{
" `kj` :: escape
inoremap kj <Esc>`^

" `lkj` :: escape + save
inoremap lkj <Esc>`^:w<CR>

" `;lkj` :: escape + save + quit
inoremap ;lkj <Esc>`^:wq<CR>

" }}}
" Terminal mode {{{
" `<Esc>` to exit terminal mode
tnoremap <Esc> <C-\><C-n>
" }}}
" Window navigation {{{
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
" }}}
" Tab navigation {{{
" `t` + {h,l,n}
nnoremap <silent> th :tabprev<CR>
nnoremap <silent> tl :tabnext<CR>
nnoremap <silent> tn :tabnew<CR>
" }}}
