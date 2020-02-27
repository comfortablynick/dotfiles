let s:guard = 'g:loaded_autoload_plugins_ultisnips' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#ultisnips#pre() abort
    let g:UltiSnipsSnippetDirectories = ['~/.config/ultisnips']
    let g:UltiSnipsExpandTrigger = '<F4>'        " Do not use <tab>
    let g:UltiSnipsJumpForwardTrigger = '<C-b>'  " Do not use <c-j>

    inoremap <silent> <expr> <Plug>MyCR
        \ mucomplete#ultisnips#expand_snippet("\<CR>")
    imap <CR> <Plug>MyCR
endfunction

" It is also possible to expand snippets or complete text using only <tab>. That
" is, when you press <tab>, if there is a snippet keyword before the cursor then
" the snippet is expanded (and you may use <tab> also to jump between the
" snippet triggers), otherwise MUcomplete kicks in. The following configuration
" achieves this kind of behaviour:

" let g:ulti_expand_or_jump_res = 0
"
" fun! TryUltiSnips()
"     if !pumvisible() " With the pop-up menu open, let Tab move down
"         call UltiSnips#ExpandSnippetOrJump()
"     endif
"     return ''
" endf
"
" fun! TryMUcomplete()
"     return g:ulti_expand_or_jump_res ? "" : "\<plug>(MUcompleteFwd)"
" endf
"
" inoremap <plug>(TryUlti) <c-r>=TryUltiSnips()<cr>
" imap <expr> <silent> <plug>(TryMU) TryMUcomplete()
" imap <expr> <silent> <tab> "\<plug>(TryUlti)\<plug>(TryMU)"
