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

" TODO: delete this if lua config is working
" let s:lsp_chain_config = {
"     \ 'default': [
"     \     {'complete_items': ['lsp', 'snippet']},
"     \     {'complete_items': ['buffers']},
"     \     {'complete_items': ['path']},
"     \     {'mode': '<c-p>'},
"     \     {'mode': '<c-n>'},
"     \     {'mode': 'file'},
"     \   ]
"     \ }
" let g:completion_chain_complete_list = {
"     \ 'default': s:lsp_chain_config,
"     \ }
