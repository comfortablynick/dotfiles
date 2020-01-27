if exists('g:loaded_autoload_plugins_coc') | finish | endif
let g:loaded_autoload_plugins_coc = 1

" Set autocmds if LC is loaded
function! plugins#coc#cmds() abort
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
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Remap only if active for filetype
function! plugins#coc#apply_maps() abort
    if exists('b:coc_suggest_disable') | return | endif
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
    nnoremap <silent> <Leader>d :CocList diagnostics<cr>
    noremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
    noremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"
    if empty(mapcheck('al', ' '))
        omap <buffer> if <Plug>(coc-funcobj-i)
        xmap <buffer> if <Plug>(coc-funcobj-i)
        omap <buffer> af <Plug>(coc-funcobj-a)
        xmap <buffer> af <Plug>(coc-funcobj-a)
    endif

    set keywordprg=:silent!\ call\ CocActionAsync('doHover')

    let g:tab_orig = maparg('<Tab>', 'n', 1)
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

function! plugins#coc#abbrev() abort
    cnoreabbrev es CocCommand snippets.editSnippets
    cnoreabbrev ci CocInfo
endfunction

function! plugins#coc#post() abort
    " let g:coc_force_debug = 1
    let g:coc_global_extensions = [
        \ 'coc-snippets',
        \ 'coc-explorer',
        \ 'coc-json',
        \ 'coc-fish',
        \ 'coc-rust-analyzer',
        \ 'coc-lua',
        \ 'coc-python',
        \ 'coc-tsserver',
        \ 'coc-tabnine',
        \ 'coc-vimlsp',
        \ 'coc-yank',
        \ 'coc-yaml',
        \ 'coc-pairs',
        \ ]

    let g:coc_filetype_map = {
        \ 'yaml.ansible': 'yaml'
        \ }

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
