if exists('g:loaded_autoload_plugins_nvim_lsp') | finish | endif
let g:loaded_autoload_plugins_nvim_lsp = 1

function! plugins#nvim_lsp#post() abort
      nnoremap <silent> ;dc <cmd>lua vim.lsp.buf.declaration()<CR>
      nnoremap <silent> ;df <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> ;h  <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <silent> ;i  <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> ;s  <cmd>lua vim.lsp.buf.signature_help()<CR>
      nnoremap <silent> ;td <cmd>lua vim.lsp.buf.type_definition()<CR>
      inoremap <silent><Leader>, <C-X><C-O>
      inoremap <silent><C-Space> <C-X><C-O>
      inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    if &l:filetype ==# 'rust'
        lua require'nvim_lsp'.rust_analyzer.setup{}
    elseif &l:filetype ==# 'python'
        lua require'nvim_lsp'["pyls_ms"].setup{ log_level = 2 }
        lua require'nvim_lsp'["pyls_ms"].manager.try_add()
    endif
    setlocal omnifunc=v:lua.vim.lsp.omnifunc
endfunction
