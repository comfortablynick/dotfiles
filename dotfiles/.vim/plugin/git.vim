" ====================================================
" Filename:    plugin/git.vim
" Description: Git-related config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-09 08:29:44 CST
" ====================================================
if exists('g:loaded_plugin_git_9vbutkh3')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_plugin_git_9vbutkh3 = 1

" Gitgutter
command -count=1 GitNextHunk call git#next_hunk(<count>)
command -count=1 GitPrevHunk call git#prev_hunk(<count>)

let g:gitgutter_map_keys = 0

silent! packadd vim-gitgutter

nnoremap <silent> ]g :GitNextHunk<CR>
nnoremap <silent> [g :GitPrevHunk<CR>
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap gs <Plug>(GitGutterPreviewHunk)

" Fugitive

silent! packadd vim-fugitive

nnoremap <silent><Leader>gs :Gstatus<CR>
nnoremap <silent><Leader>gp :Gpush<CR>
nnoremap <silent><Leader>gd :Gvdiffsplit!<CR>
" TODO: use only in &diff
nnoremap <silent><Leader>gh :diffget //2<CR>
nnoremap <silent><Leader>gl :diffget //3<CR>
