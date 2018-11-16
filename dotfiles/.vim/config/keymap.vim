" KEYMAPPING ====================================

" Normal ----------------------------------------
" <Space> :: toggle folds
noremap <Space> za

" za :: Open all folds
noremap za zA

" F10 to toggle quickfix window for asyncrun
noremap <silent> <F10> :call asyncrun#quickfix_toggle(6)<cr>

" `F5` :: toggle UndoTree
noremap <silent><F5> :UndotreeToggle \| :UndotreeFocus<CR>

" INSERT ----------------------------------------

" `kj` :: escape
inoremap kj <Esc>`^

" `lkj` :: escape + save
inoremap lkj <Esc>`^:w<CR>

" `;lkj` :: escape + save + quit
inoremap ;lkj <Esc>`^:wq<CR>

" `Ctrl+n` :: toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" TERMINAL --------------------------------------

" `<Esc>` to exit terminal mode
tnoremap <Esc> <C-\><C-n>

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
