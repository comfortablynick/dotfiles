command -count=1 GitNextHunk call git#next_hunk(<count>)
command -count=1 GitPrevHunk call git#prev_hunk(<count>)

function! plugins#gitgutter#pre() abort
    let g:gitgutter_map_keys = 0
endfunction

function! plugins#gitgutter#post() abort
    nnoremap <silent> ]g :GitNextHunk<CR>
    nnoremap <silent> [g :GitPrevHunk<CR>
    nmap ghs <Plug>(GitGutterStageHunk)
    nmap ghu <Plug>(GitGutterUndoHunk)
    nmap gs <Plug>(GitGutterPreviewHunk)
endfunction
