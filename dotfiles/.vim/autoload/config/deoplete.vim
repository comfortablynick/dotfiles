function! config#deoplete#init() abort
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#sources#jedi#show_docstring = 1
    let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
    let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
    augroup config_deoplete
        autocmd!
        autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
    augroup END

    packadd deoplete.nvim
    packadd deoplete-jedi
    packadd deoplete-fish
    silent! UpdateRemotePlugins
endfunction
