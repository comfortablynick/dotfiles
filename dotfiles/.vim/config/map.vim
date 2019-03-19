" vim:fdl=1
"                             _
"  _ __ ___   __ _ _ ____   _(_)_ __ ___
" | '_ ` _ \ / _` | '_ \ \ / / | '_ ` _ \
" | | | | | | (_| | |_) \ V /| | | | | | |
" |_| |_| |_|\__,_| .__(_)_/ |_|_| |_| |_|
"                 |_|
"
" KEYMAPS

" Leader key
let g:mapleader = ','

" Editor {{{1
" Indent/outdent {{{2
nnoremap <Leader><Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv
inoremap <S-Tab> <C-d>

" Folds {{{2
" Toggle folds
noremap <Space> za

" Open all folds under cursor
noremap za zA

" Undo/Redo {{{2
" `U` to redo
nnoremap U <C-r>

" Insert mode <Esc> maps {{{2
" `kj` :: escape
inoremap kj <Esc>`^

" `lkj` :: escape + save
inoremap lkj <Esc>`^:w<CR>

" `;lkj` :: escape + save + quit
inoremap ;lkj <Esc>`^:wq<CR>

" Matching pairs {{{2
" inoremap <>   <><Left>
" inoremap ()   ()<Left>
" inoremap {}   {}<Left>
" inoremap []   []<Left>
" inoremap ""   ""<Left>
" inoremap ''   ''<Left>
" inoremap ``   ``<Left>

" Line navigation {{{2
" Easy navigation in insert mode
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" Windows/splits {{{1
" Navigation {{{2
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

" Delete windows {{{2
" Delete window to the left/below/above/to the right with d<C-h/j/k/l>.
nnoremap d<C-j> <C-w>j<C-w>c
nnoremap d<C-k> <C-w>k<C-w>c
nnoremap d<C-h> <C-w>h<C-w>c
nnoremap d<C-l> <C-w>l<C-w>c

" Quickfix toggle {{{2
nnoremap <silent> <Leader>q :call ToggleQf()<CR>
noremap <silent> <F10> :call ToggleQf()<CR>

" Tabs {{{1
" Navigation {{{2
" `t` + {h,l,n} to navigate tabs
nnoremap <silent> th :tabprev<CR>
nnoremap <silent> tl :tabnext<CR>
nnoremap <silent> tn :tabnew<CR>

" Running commands {{{1
" Vim-tmux-runner {{{2
nnoremap <silent> <Leader>a :VtrAttachToPane<CR>
nnoremap <silent> <Leader>x :VtrKillRunner<CR>
noremap <silent> <C-b> :VtrSendFile!<CR>
noremap <silent> <C-x> :VtrKillRunner<CR>


" RunCmd() {{{2
nnoremap <silent> <Leader>r :call RunCmd('run')<CR>
nnoremap <silent> <Leader>w :w \| :call RunCmd('install')<CR>
nnoremap <silent> <Leader>b :call RunCmd('build')<CR>

" RunBuild() {{{2
noremap <silent> <F7> :call RunBuild()<CR>

" SetExecutableBit() {{{2
nnoremap <F3> :call SetExecutable()<CR>

" Plugins {{{1
" ALE {{{2
nmap <silent> <Leader>f <Plug>(ale_next_wrap)
nmap <silent> <Leader>g <Plug>(ale_previous_wrap)

" Coc language client {{{2
" Remap only if active for filetype
function LC_maps() abort
    if exists('g:did_coc_loaded')
        nnoremap <silent> gh :call CocActionAsync('doHover')<CR>
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gr <Plug>(coc-rename)
        nmap <silent> gt <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gy <Plug>(coc-references)
        nmap <silent> <Leader>f <Plug>(coc-diagnostic-next)
        nmap <silent> <Leader>g <Plug>(coc-diagnostic-prev)
        nnoremap <silent> <Leader>d :CocList diagnostics<cr>
    endif
endfunction

augroup LC
    autocmd!
    autocmd FileType * call LC_maps()
augroup END

" Paste from register
nnoremap <Leader>0 "0p<CR>
nnoremap <Leader>1 "1p<CR>
nnoremap <Leader>2 "2p<CR>
nnoremap <Leader>3 "3p<CR>
nnoremap <Leader>4 "4p<CR>

" Tagbar {{{2
nnoremap <silent> <Leader>t :TagbarToggle<CR>
" `F8` :: toggle TagBar
noremap <silent> <F8> :TagbarToggle<CR>

" NERDTree {{{2
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
noremap <silent> <C-n> :NERDTreeToggle<CR>

" UndoTree {{{2
noremap <silent> <F5> :UndotreeToggle \| :UndotreeFocus<CR>

" Neoformat {{{2
noremap <silent> <F2> :Neoformat<CR>

" Fzf {{{2
" Search command history
noremap <silent> <C-r> :History:<CR>
noremap <silent> <C-t> :BTags<CR>
nnoremap <silent> <Leader>m :BTags<CR>
nnoremap <silent> <Leader>l :BLines<CR>
nnoremap <silent> <Leader>k :call fzf#vim#buffer_tags('^' . expand('<cword>'))<CR>
" nnoremap <leader>k :call fzf#vim#buffer_lines(expand('<cword>'))<CR>
