" KEYMAPPING ====================================

"kj escapes in INSERT mode
inoremap kj <Esc>`^

" lkj escapes and saves in INSERT mode
inoremap lkj <Esc>`^:w<CR>

" ;lkj escapes, saves, and quits in INSERT mode
inoremap ;lkj <Esc>`^:wq<CR>

" Ctrl+n opens NERDTree
map <C-n> :NERDTreeToggle<CR>
