function! plugins#signify#pre() abort
    nmap ]g <Plug>(signify-next-hunk)
    nmap [g <Plug>(signify-prev-hunk)
    nnoremap <silent> <Leader>gu :SignifyHunkUndo<CR>
    nnoremap <silent> gs :SignifyHunkDiff<CR>
endfunction

let g:signify_line_highlight = 0
