function! plugins#coc#pre() abort "{{{1
    " let g:coc_force_debug = 1
    let g:coc_filetype_map = {
        \ 'yaml.ansible': 'yaml'
        \ }
    let g:coc_global_extensions = [
        \ 'coc-snippets',
        \ 'coc-explorer',
        \ 'coc-git',
        \ 'coc-json',
        \ 'coc-fish',
        \ 'coc-rust-analyzer',
        \ 'coc-python',
        \ 'coc-tsserver',
        \ 'coc-vimlsp',
        \ 'coc-yaml',
        \ 'coc-pairs',
        \ 'coc-actions',
        \ ]

    if $MOSH_CONNECTION
        let g:coc_user_config = {
            \ 'explorer.icon.enableNerdfont': v:false,
            \ 'explorer.icon.enableVimDevicons': v:false,
            \}
    endif
endfunction

function! plugins#coc#preconfig() abort "{{{1
    " This has to be called explicitly before the plugin loads
endfunction


function! plugins#coc#cmds() abort "{{{1
    if ! coc#rpc#ready() || exists('b:coc_suggest_disable') | return | endif
    augroup coc_config_auto
        autocmd!
        if get(b:, 'coc_disable_cursorhold_hover', 1) == 0 ||
            \ get(b:, 'coc_enable_cursorhold_hover', 0) == 1
            autocmd CursorHold * silent
                \ if ! coc#util#has_float() | call CocActionAsync('doHover') | endif
        endif
        autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup END
endfunction

" Helper function for <TAB> completion keymap
function! s:check_back_space() abort "{{{1
    let l:col = col('.') - 1
    return !l:col || getline('.')[l:col - 1]  =~# '\s'
endfunction

" Remap only if active for filetype
function! plugins#coc#apply_maps() abort "{{{1
    if exists('b:coc_suggest_disable') | return | endif
    " Capture any existing maps
    let l:coc_existing_maps = map#save([
        \ '<C-f>',
        \ '<C-b>',
        \ ], 'n', 1)

    nnoremap <silent> gh :call CocAction('doHover')<CR>
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gr <Plug>(coc-rename)
    nmap <silent> <F2> <Plug>(coc-rename)
    nmap <silent> gt <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gy <Plug>(coc-references)
    nmap <silent> ge :CocCommand explorer --toggle<CR>
    nmap <silent> <Leader>l :CocList<CR>
    nmap <silent> <Leader>f <Plug>(coc-diagnostic-next)
    nmap <silent> <Leader>g <Plug>(coc-diagnostic-prev)
    nnoremap <silent> <Leader>d :CocList diagnostics<CR>

    let l:cf = l:coc_existing_maps['<C-f>']['rhs']
    let l:cb = l:coc_existing_maps['<C-b>']['rhs']
    exe 'nmap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "'.l:cf.'"'
    exe 'nmap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "'.l:cb.'"'
    if empty(maparg('if', 'x'))
        omap <buffer> if <Plug>(coc-funcobj-i)
        xmap <buffer> if <Plug>(coc-funcobj-i)
        omap <buffer> af <Plug>(coc-funcobj-a)
        xmap <buffer> af <Plug>(coc-funcobj-a)
    endif

    " coc-git
    if index(g:coc_global_extensions, 'coc-git') > -1
        nmap [g <Plug>(coc-git-prevchunk)
        nmap ]g <Plug>(coc-git-nextchunk)
        nmap gs <Plug>(coc-git-chunkinfo)
        nmap gc <Plug>(coc-git-commit)
        nnoremap <Leader>gu :CocCommand git.chunkUndo<CR>
        nnoremap <Leader>gs :CocCommand git.chunkStage<CR>
        nnoremap <Leader>gf :CocCommand git.foldUnchanged<CR>
    endif

    if index(g:coc_global_extensions, 'coc-actions') > -1
        xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open' visualmode()<CR>
        nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>coc_actions_open_from_selection<CR>g@
    endif

    set keywordprg=:silent!\ call\ CocActionAsync('doHover')

    " Use <TAB> to scroll completion results and jump through snippets
    inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ coc#expandableOrJumpable() ? coc#rpc#request('doKeymap', ['snippets-expand-jump','']) :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()

    " Use S-TAB to scroll backward
    inoremap <silent><expr> <S-TAB>
        \ pumvisible() ? "\<C-p>" : "\<S-TAB>"

    " Use <CR> to select snippet/completion
    inoremap <silent><expr> <CR>
        \ complete_info()['selected'] != '-1' ? "\<C-y>" : "\<C-g>u\<CR>"

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call CocAction('fold', <f-args>)
endfunction

function! s:coc_actions_open_from_selection(type) abort "{{{1
    execute 'CocCommand actions.open' a:type
endfunction

function! plugins#coc#abbrev() abort "{{{1
    call map#set_cabbr('es', 'CocCommand snippets.editSnippets')
    call map#set_cabbr('ci', 'CocInfo')
    call map#set_cabbr('cc', 'CocConfig')
endfunction

function! plugins#coc#init() abort "{{{1
    if get(g:, 'use_explorer_coc', 'coc-explorer') ==# 'coc-explorer'
        let g:use_explorer = 'coc-explorer'
    endif
    let g:coc_status_error_sign = 'E'
    let g:coc_status_warn_sign = 'W'
    let g:coc_snippet_next = '<tab>'
    call plugins#coc#cmds()
    call plugins#coc#apply_maps()
    call plugins#coc#abbrev()
endfunction
