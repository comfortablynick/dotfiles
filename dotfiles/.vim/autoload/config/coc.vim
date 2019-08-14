" Coc.nvim configuration

" Set autocmds if LC is loaded
function! config#coc#cmds() abort
    if ! coc#rpc#ready() || exists('b:coc_suggest_disable')
        return
    endif
    augroup coc_config_auto
        autocmd!
        if get(b:, 'coc_disable_cursorhold_hover', 1) == 0 ||
            \ get(b:, 'coc_enable_cursorhold_hover', 0) == 1
            autocmd CursorHold * silent
                \ if ! coc#util#has_float() | call CocActionAsync('doHover') | endif
        endif
        if get(b:, 'coc_disable_cursorhold_highlight', 0) == 0
            autocmd CursorHold * silent call CocActionAsync('highlight')
        endif
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
        " autocmd InsertEnter * call CocActionAsync('showSignatureHelp')
    augroup END
endfunction

" Helper function for <TAB> completion keymap
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Remap only if active for filetype
function! config#coc#maps() abort
    if exists('b:coc_suggest_disable')
        return
    endif
    nnoremap <silent> gh :call CocAction('doHover')<CR>
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gr <Plug>(coc-rename)
    nmap <silent> gt <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gy <Plug>(coc-references)

    " coc-git
    nmap [g <Plug>(coc-git-prevchunk)
    nmap ]g <Plug>(coc-git-nextchunk)
    nmap gs <Plug>(coc-git-chunkinfo)
    nmap gc <Plug>(coc-git-commit)

    nmap <silent> <Leader>f <Plug>(coc-diagnostic-next)
    nmap <silent> <Leader>g <Plug>(coc-diagnostic-prev)
    nnoremap <silent> <Leader>d :CocList diagnostics<cr>
    noremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
    noremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"

    " Map <TAB> as key to scroll completion results and jump through
    " snippets
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ coc#expandableOrJumpable() ? coc#rpc#request('doKeymap', ['snippets-expand-jump','']) :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

    " Use <CR> to select snippet/completion
    inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " inoremap <silent><expr> <CR>
    "     \ pumvisible() ? coc#_select_confirm() :
    "     \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call CocAction('fold', <f-args>)
endfunction

function! config#coc#init() abort
    let g:coc_status_error_sign = 'E'
    let g:coc_status_warn_sign = 'W'
    let g:coc_snippet_next = '<tab>'
    call config#coc#cmds()
    call config#coc#maps()
endfunction
