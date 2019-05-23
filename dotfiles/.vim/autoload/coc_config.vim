" Coc.nvim configuration

" Set autocmds if LC is loaded
function! coc_config#cmds() abort
    if ! coc#rpc#ready() || exists('b:coc_suggest_disable')
        return
    endif
    autocmd coc_config CursorHold *
        \ if ! coc#util#has_float() | silent! call CocActionAsync('doHover') | endif
    autocmd coc_config User CocJumpPlaceholder silent! call CocActionAsync('showSignatureHelp')
    autocmd coc_config InsertEnter * call CocActionAsync('showSignatureHelp')
endfunction

" Helper function for <TAB> completion keymap
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Remap only if active for filetype
function! coc_config#maps() abort
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
    nnoremap <silent> <Leader>m :call vista#finder#fzf#Run('coc')<CR>
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
endfunction

function! coc_config#init() abort
    call coc_config#cmds()
    call coc_config#maps()
endfunction