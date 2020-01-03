" ====================================================
" Filename:    plugin/git.vim
" Description: Git-related config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-03
" ====================================================
if exists('g:loaded_plugin_git_9vbutkh3') | finish | endif
let g:loaded_plugin_git_9vbutkh3 = 1

" Gitgutter

let g:gitgutter_map_keys = 0

silent! packadd vim-gitgutter

nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap gs <Plug>(GitGutterPreviewHunk)

" Signify

" nmap ]g <Plug>(signify-next-hunk)
" nmap [g <Plug>(signify-prev-hunk)
" nmap <silent> ghu :SignifyHunkUndo<CR>
" nmap <silent> gs  :SignifyHunkDiff<CR>

" silent! packadd vim-signify

" Fugitive

silent! packadd vim-fugitive

nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gd :Gvdiffsplit!<CR>
" TODO: use only in &diff
nnoremap <Leader>gh :diffget //2<CR>
nnoremap <Leader>gl :diffget //3<CR>
