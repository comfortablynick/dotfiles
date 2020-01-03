" ====================================================
" Filename:    plugin/git.vim
" Description: Git-related plugin config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-03
" ====================================================
if exists('g:loaded_plugin_git_9vbutkh3') | finish | endif
let g:loaded_plugin_git_9vbutkh3 = 1

" Don't load if we're using coc (use coc-git instead)
" augroup plugin_gitgutter_9vbutkh3
"     autocmd!
"     autocmd FileType *
"         \ if exists('g:completion_filetypes')
"         \ && index(g:completion_filetypes['coc'], &filetype) < 0
"         \ | packadd vim-gitgutter
"         \ | endif
" augroup END
" Settings before load
" let g:gitgutter_map_keys = 0

" silent! packadd vim-gitgutter

" nmap ]g <Plug>(GitGutterNextHunk)
" nmap [g <Plug>(GitGutterPrevHunk)
" nmap ghs <Plug>(GitGutterStageHunk)
" nmap ghu <Plug>(GitGutterUndoHunk)
" nmap gs <Plug>(GitGutterPreviewHunk)

nmap ]g <Plug>(signify-next-hunk)
nmap [g <Plug>(signify-prev-hunk)
" nmap ghs :Signify
nmap <silent> ghu :SignifyHunkUndo<CR>
nmap <silent> gs  :SignifyHunkDiff<CR>

silent! packadd vim-signify
