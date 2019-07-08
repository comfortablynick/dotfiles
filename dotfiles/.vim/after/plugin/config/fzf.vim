" Fzf.vim commands/config
if exists('g:loaded_fzf_config_vim') || ! exists(':FZF')
    finish
endif
let g:loaded_fzf_config_vim = 1

" Rg with preview window
"   :Rg  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Rg! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Rg call
    \ fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
    \ <bang>0 ? fzf#vim#with_preview('up:60%')
    \         : fzf#vim#with_preview('right:60%:hidden', '?'),
    \ <bang>0
    \ )

" Ag with preview window
"   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
"   :Ag! - Start fzf in fullscreen and display the preview window above
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:60%:hidden', '?'),
  \                 <bang>0)

" Files command with preview window
command! -bang -nargs=* -complete=dir Files
  \ call fzf#vim#files(<q-args>,
  \                    <bang>0 ? fzf#vim#with_preview('up:60%')
  \                            : fzf#vim#with_preview('right:60%', '?'),
  \                    <bang>0)

" use bottom split
let g:fzf_layout = { 'down': '~30%' }
let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Clear'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment']
    \ }

if has('nvim') || has('gui_running')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

" Maps
" Search command history
noremap <silent> <C-r> :History:<CR>

" Tags
noremap <silent> <C-t> :BTags<CR>
nnoremap <silent> <Leader>k :call fzf#vim#buffer_tags('^' . expand('<cword>'))<CR>

" Search/lines
nnoremap <silent> <Leader>l :BLines<CR>

augroup fzf_config
    autocmd!
    " Add fzf vista finder if not a coc filetype
    autocmd FileType *
        \ if ! exists('g:completion_filetypes') ||
        \ index(g:completion_filetypes['coc'], &filetype) < 0
        \ | nnoremap <silent> <Leader>m :call vista#finder#fzf#Run()<CR>
        \ | endif
    " Don't show status bar in fzf window
    autocmd FileType fzf set laststatus=0 noruler
        \| autocmd BufLeave <buffer> set laststatus=2 ruler
augroup END
