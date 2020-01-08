" ====================================================
" Filename:    plugin/git.vim
" Description: Git-related config
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:51:01 CST
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

nmap <silent> ]g :GitNextHunk<CR>
nmap <silent> [g :GitPrevHunk<CR>
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap gs <Plug>(GitGutterPreviewHunk)

" Fugitive

silent! packadd vim-fugitive

nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gd :Gvdiffsplit!<CR>
" TODO: use only in &diff
nnoremap <Leader>gh :diffget //2<CR>
nnoremap <Leader>gl :diffget //3<CR>
