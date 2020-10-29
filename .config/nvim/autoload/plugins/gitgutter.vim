function plugins#gitgutter#pre()
    let g:gitgutter_map_keys = 0
    call s:set_gitgutter_highlights()
endfunction

function s:set_gitgutter_highlights()
    highlight link GitGutterAdd                DiffAdd
    highlight link GitGutterChange             DiffChange
    highlight link GitGutterDelete             DiffDelete
    highlight link GitGutterAddLineNr          GitGutterAdd
    highlight link GitGutterChangeLineNr       GitGutterChange
    highlight link GitGutterDeleteLineNr       GitGutterDelete
    highlight link GitGutterChangeDeleteLineNr GitGutterChange
endfunction

augroup autoload_plugins_gitgutter
    autocmd!
    autocmd ColorScheme * call s:s:set_gitgutter_highlights()
augroup END

" Preserve diff mode functionality for navigating changes
nnoremap <silent> <expr> <plug>(gitgutter-hunk-next)
    \ &diff ? ']c' : ":\<c-u>call <SID>gitgutter_hunk_next(v:count1)\<CR>"
nnoremap <silent> <expr> <plug>(gitgutter-hunk-prev)
    \ &diff ? '[c' : ":\<c-u>call <SID>gitgutter_hunk_prev(v:count1)\<CR>"

nmap         ]c  <Plug>(gitgutter-hunk-next)
nmap         [c  <Plug>(gitgutter-hunk-prev)
nmap <Leader>gs  <Plug>(GitGutterStageHunk)
nmap <Leader>gu  <Plug>(GitGutterUndoHunk)
nmap         gs  <Plug>(GitGutterPreviewHunk)

" Wrap around buffer when navigating hunks
function s:gitgutter_hunk_prev(count)
    for l:i in range(1, a:count)
        let l:line = line('.')
        silent GitGutterPrevHunk
        if line('.') == l:line
            normal! G
            silent GitGutterPrevHunk
        endif
    endfor
endfunction

function s:gitgutter_hunk_next(count)
    for l:i in range(1, a:count)
        let l:line = line('.')
        silent GitGutterNextHunk
        if line('.') == l:line
            normal! 1G
            silent GitGutterNextHunk
        endif
    endfor
endfunction
