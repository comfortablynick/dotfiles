let s:guard = 'g:loaded_autoload_plugins_ultisnips' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#ultisnips#pre() abort
    " Remap UltiSnips triggers so they don't interfere with mucomplete
    let g:UltiSnipsExpandTrigger = '<C-s>'
    let g:UltiSnipsJumpForwardTrigger = '<C-right>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-left>'
    let g:UltiSnipsSnippetDirectories = ['~/.config/ultisnips']

    " Define <Plug> mappings
    inoremap <expr> <Plug>(MyCR)
        \ mucomplete#ultisnips#expand_snippet("\<cr>")
    inoremap <Plug>(TryUlti) <C-R>=<SID>try_ultisnips()<CR>
    imap <expr> <Plug>(TryMU) <SID>try_mucomplete()

    " Try to expand snippet, then try completion
    imap <expr> <silent> <Tab>
        \ "\<Plug>(TryUlti)\<Plug>(TryMU)"
    imap <silent> <CR> <Plug>(MyCR)
    " Map tab in select mode to allow tabbing from selected default value
    snoremap <silent> <Tab> <C-O>:call UltiSnips#ExpandSnippetOrJump()<CR>

    " Use fzf for listing snippets
    inoremap <C-s> <C-O>:Snippets<CR>

    cnoreabbrev <expr> es
        \ map#cabbr('es', 'UltiSnipsEdit')
endfunction

" It is also possible to expand snippets or complete text using only <tab>. That
" is, when you press <tab>, if there is a snippet keyword before the cursor then
" the snippet is expanded (and you may use <tab> also to jump between the
" snippet triggers), otherwise MUcomplete kicks in. The following configuration
" achieves this kind of behaviour:


function! s:try_ultisnips() abort
    let g:ulti_expand_or_jump_res = 0
    if !pumvisible() " With the pop-up menu open, let Tab move down
        call UltiSnips#ExpandSnippetOrJump()
    endif
    return ''
endf

function! s:try_mucomplete() abort
    return g:ulti_expand_or_jump_res ? '' : "\<plug>(MUcompleteFwd)"
endf
