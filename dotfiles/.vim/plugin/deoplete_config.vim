" Deoplete config

if exists('g:loaded_deoplete_config')
    finish
endif

let g:loaded_deoplete_config = 1

let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

inoremap <expr><tab> pumvisible() && exists('g:loaded_deoplete') ? "\<c-n>" : "\<tab>"
autocmd vimrc CompleteDone * if pumvisible() && exists('g:loaded_deoplete') == 0 | pclose | endif
