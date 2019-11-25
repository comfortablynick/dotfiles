" vim:fdl=1
"                             _
"  _ __ ___   __ _ _ ____   _(_)_ __ ___
" | '_ ` _ \ / _` | '_ \ \ / / | '_ ` _ \
" | | | | | | (_| | |_) \ V /| | | | | | |
" |_| |_| |_|\__,_| .__(_)_/ |_|_| |_| |_|
"                 |_|
"
" General Keymaps

" Leader key
let g:mapleader = ','

" Indent/outdent
vnoremap <Tab>   >><Esc>gv
vnoremap <S-Tab> <<<Esc>gv

" Toggle folds
noremap <Space> za

" Open all folds under cursor
noremap za zA

" `U` to redo
nnoremap U <C-r>

" Insert mode <Esc> maps
" `kj` :: escape
inoremap kj <Esc>`^

" `lkj` :: escape + save
inoremap lkj <Esc>`^:w<CR>

" `;lkj` :: escape + save + quit
inoremap ;lkj <Esc>`^:wq<CR>

" Search - CR turns off search highlighting
nnoremap <CR> :nohlsearch<CR><CR>

" Use q to close buffer on read-only files
autocmd vimrc FileType netrw,help nnoremap <silent> q :bd<CR>

" View highlight under cursor
nnoremap <Leader>h :echo syntax#syn_group()<CR>
