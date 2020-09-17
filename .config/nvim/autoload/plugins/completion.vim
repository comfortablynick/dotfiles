let s:guard = 'g:loaded_autoload_plugins_completion' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion

set shortmess+=c

let g:completion_enable_snippet = 'snippets.nvim'
let g:completion_enable_auto_paren = 1
let g:completion_auto_change_source = 1
let g:completion_customize_lsp_label = {'Buffer': 'B', 'Buffers': 'Bs'}
