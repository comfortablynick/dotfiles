if exists('g:loaded_autoload_plugins_nvim_lsp') | finish | endif
let g:loaded_autoload_plugins_nvim_lsp = 1

function! plugins#nvim_lsp#post() abort
    lua require'lsp'.init()
    return
endfunction

function! plugins#nvim_lsp#maps() abort
    nnoremap <silent>  ;d <Cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent>  gd <Cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent>  gh <Cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent>  gi <Cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent>  ;s <Cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent>  gt <Cmd>lua vim.lsp.buf.type_definition()<CR>
    nnoremap <silent><F2> <Cmd>lua vim.lsp.buf.rename()<CR>
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
    " call plugins#nvim_lsp#maps()
    call plugins#nvim_lsp#autocmds()
endfunction
