"                             _
"  _ __ ___   __ _ _ ____   _(_)_ __ ___
" | '_ ` _ \ / _` | '_ \ \ / / | '_ ` _ \
" | | | | | | (_| | |_) \ V /| | | | | | |
" |_| |_| |_|\__,_| .__(_)_/ |_|_| |_| |_|
"                 |_|
"
" KEYMAPS
" Global {{{1
" `<comma>` :: <Leader> (g:mapleader)
let g:mapleader = ','

" `Ctrl+n` :: toggle NERDTree
noremap <silent> <C-n> :NERDTreeToggle<CR>

" Vim-tmux-runner (Run code)
noremap <silent> <C-b> :VtrSendFile!<CR>
noremap <silent> <C-x> :VtrKillRunner<CR>

" <Space> :: toggle folds
noremap <Space> za

" za :: Open all folds
noremap za zA

" `F2` :: Run Neoformat
noremap <silent> <F2> :Neoformat<CR>

" `F5` :: toggle UndoTree
noremap <silent> <F5> :UndotreeToggle \| :UndotreeFocus<CR>

" `F7` :: build project
noremap <silent> <F7> :call RunBuild()<CR>

" `F8` :: toggle TagBar
noremap <silent> <F8> :TagbarToggle<CR>

" F10 to toggle quickfix window for asyncrun
noremap <silent> <F10> :call ToggleQf()<CR>

" Normal mode {{{1
" <Shift>+Tab :: Move back in jump list
nnoremap <silent> <S-Tab> <C-O>

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Vim-tmux-runner
nnoremap <silent> <Leader>a :VtrAttachToPane<CR>
nnoremap <silent> <Leader>r :VtrSendFile!<CR>

" Build
nnoremap <silent> <Leader>w :w \| :call RunBuild()<CR>

" Quickfix
nnoremap <silent> <Leader>q :call ToggleQf()<CR>

" Tagbar
nnoremap <silent> <Leader>t :TagbarToggle<CR>

" NERDTree
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>

" ALE
nmap <silent> <Leader>f <Plug>(ale_next_wrap)
nmap <silent> <Leader>g <Plug>(ale_previous_wrap)

" SetExecutableBit()
nnoremap <F3> :call SetExecutable()<CR>

" Paste from register
nnoremap <Leader>0 "0p<CR>
nnoremap <Leader>1 "1p<CR>
nnoremap <Leader>2 "2p<CR>
nnoremap <Leader>3 "3p<CR>
nnoremap <Leader>4 "4p<CR>

" Insert mode {{{1
" `kj` :: escape
inoremap kj <Esc>`^

" `lkj` :: escape + save
inoremap lkj <Esc>`^:w<CR>

" `;lkj` :: escape + save + quit
inoremap ;lkj <Esc>`^:wq<CR>


" Terminal mode {{{1
" `<Esc>` to exit terminal mode
tnoremap <Esc> <C-\><C-n>

" Window navigation {{{1
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

" Tab navigation {{{1
" `t` + {h,l,n}
nnoremap <silent> th :tabprev<CR>
nnoremap <silent> tl :tabnext<CR>
nnoremap <silent> tn :tabnew<CR>
