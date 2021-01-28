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

" TODO: turn this into snippet
let g:timefmts = [
    \ '%Y-%m-%d %H:%M:%S',
    \ '%a, %d %b %Y %H:%M:%S %z',
    \ '%Y %b %d',
    \ '%d-%b-%y',
    \ '%a %b %d %T %Z %Y',
    \ ]
inoremap <silent><C-G><C-T> <C-R>=repeat(complete(col('.'),map(g:timefmts,{_,v->strftime(v)})),0)<CR>

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

" `ALT+{h,j,k,l}` resize vim/tmux panes in normal mode {{{2
" Note: vim has trouble with Meta/Alt key
nnoremap <A-h> <Cmd>call window#tmux_aware_resize('h')<CR>
nnoremap <A-j> <Cmd>call window#tmux_aware_resize('j')<CR>
nnoremap <A-k> <Cmd>call window#tmux_aware_resize('k')<CR>
nnoremap <A-l> <Cmd>call window#tmux_aware_resize('l')<CR>

" `ALT+{h,j,k,l}` to navigate windows from other modes {{{2
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
nnoremap <silent> [t <Cmd>tabprevious<CR>
nnoremap <silent> ]t <Cmd>tabnext<CR>

" Buffer navigation {{{1
nnoremap <Tab>      <Cmd>bnext<CR>
nnoremap <S-Tab>    <Cmd>bprevious<CR>
nnoremap <Leader>w  <Cmd>update\|bwipeout<CR>
nnoremap <Leader>u  <Cmd>update\|Bdelete<CR>
nnoremap <Leader>q  <Cmd>Bdelete<CR>
nnoremap <Leader>xx <Cmd>BufOnly<CR>

" Quickfix
nnoremap cq <Cmd>call quickfix#toggle()<CR>

" Command line {{{1
" %% -> cwd
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" Format/indent {{{1
" Format buffer and restore cursor position
nnoremap <Leader>ff <Cmd>call buffer#restore_cursor_after('gggqG')<CR>
" Indent buffer and restore cursor position
nnoremap <Leader>fi <Cmd>call buffer#restore_cursor_after('gg=G')<CR>

" Insert mode escape {{{2
" This works well, but it creates undo points and sometimes results in lost work
" Regular maps work well if timeoutlen is set low

" let s:escape_string = 'kj'
" let s:escape_timeout_ms = 100
" let s:escape_start_key = s:escape_string[0]
" let s:escape_end_key = s:escape_string[1]
" let s:escape_sequence = "\<BS>\<Esc>`^"
"
" function s:escape_map_start(char)
"     let s:escape_timestamp = reltime()
"     return a:char
" endfunction
"
" function s:escape_map_end(char)
"     if !exists('s:escape_timestamp') | return a:char | endif
"     let l:elapsed_ms = reltimefloat(reltime(s:escape_timestamp)) * 1000
"     unlet s:escape_timestamp
"     if l:elapsed_ms > s:escape_timeout_ms
"         let b:escape_edited = 1
"         return a:char
"     endif
"
"     let l:line_check_empty = getline('.')
"     if l:line_check_empty ==# s:escape_start_key | return s:escape_sequence | endif
"
"     let l:trimmed  = substitute(l:line_check_empty, '^\s*\(.\{-}\)\s*$', '\1', '')
"     if l:trimmed ==# s:escape_start_key
"         return "\<BS>\<C-w>\<Esc>"
"     else
"         return s:escape_sequence
"     endif
" endfunction
"
" " execute 'inoremap <expr>' s:escape_start_key '<SID>escape_map_start("'..s:escape_start_key..'")'
" " execute 'inoremap <expr>' s:escape_end_key   '<SID>escape_map_end("'..  s:escape_end_key  ..'")'
"
" function s:escape_insert_char_pre()
"     if v:char !=# s:escape_start_key && v:char !=# s:escape_end_key
"         let b:escape_edited = 1
"     endif
" endfunction
"
" augroup insert_escape_maps
"     autocmd!
"     autocmd InsertCharPre *  call s:escape_insert_char_pre()
"     autocmd InsertEnter   *  let b:escape_edited = &modified
"     autocmd InsertLeave   *  if b:escape_edited == 0 | setl nomod | endif
" augroup END

" vim:fdl=1:
