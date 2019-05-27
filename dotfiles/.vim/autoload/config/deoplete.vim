function! config#deoplete#init() abort
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#sources#jedi#show_docstring = 1
    let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
    let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
    autocmd vimrc CompleteDone * if pumvisible() == 0 | pclose | endif
    packadd deoplete.nvim
    silent! UpdateRemotePlugins
endfunction
