" ====================================================
" Filename:    after/plugin/config/fzf.vim
" Description: Configure settings and commands for FZF
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-09 16:11:24 CST
" ====================================================
if exists('g:loaded_fzf_config_vim') || ! exists(':FZF') | finish | endif
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

let g:fzf_layout = { 'window': 'lua require"window".new_centered_floating()' }
" let g:fzf_layout = { 'down': '~30%' } " bottom split
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
noremap  <silent> <C-r>      :History:<CR>
nnoremap <silent> <Leader>gg :Rg<CR>

augroup fzf_config
    autocmd!
    autocmd FileType fzf silent! tunmap <buffer> <Esc>
augroup END
