if exists('g:loaded_autoload_plugins_nvim_lsp') | finish | endif
let g:loaded_autoload_plugins_nvim_lsp = 1

function! plugins#nvim_lsp#maps() abort
    nnoremap <silent>;d <Cmd>call v:lua.vim.lsp.buf.declaration()<CR>
    nnoremap <silent>gd <Cmd>call v:lua.vim.lsp.buf.definition()<CR>
    nnoremap <silent>gh <Cmd>call v:lua.vim.lsp.buf.hover()<CR>
    nnoremap <silent>gi <Cmd>call v:lua.vim.lsp.buf.implementation()<CR>
    nnoremap <silent>;s <Cmd>call v:lua.vim.lsp.buf.signature_help()<CR>
    nnoremap <silent>gt <Cmd>call v:lua.vim.lsp.buf.type_definition()<CR>
    inoremap <silent><Leader>, <C-X><C-O>
    inoremap <silent><C-Space> <C-X><C-O>
    inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    setlocal omnifunc=v:lua.vim.lsp.omnifunc
endfunction

function! plugins#nvim_lsp#autocmds() abort
    augroup autoload_nvim_lsp
        autocmd!
        autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
    augroup END
endfunction

function! plugins#nvim_lsp#init() abort
    silent! packadd nvim-lsp

lua << EOF
local lsp = require'nvim_lsp'
lsp.pyls_ms.setup{ log_level = 2 }
lsp.pyls_ms.manager.try_add()
lsp.rust_analyzer.setup{}
EOF

    call plugins#nvim_lsp#maps()
    call plugins#nvim_lsp#autocmds()
endfunction
