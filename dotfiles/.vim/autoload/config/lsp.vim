" ====================================================
" Filename:    autoload/config/lsp.vim
" Description: Config for builtin lsp
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-24
" ====================================================

function config#lsp#init() abort
    " silent! packadd nvim-lsp
      nnoremap <silent> ;dc <cmd>lua vim.lsp.buf.declaration()<CR>
      nnoremap <silent> ;df <cmd>lua vim.lsp.buf.definition()<CR>
      nnoremap <silent> ;h  <cmd>lua vim.lsp.buf.hover()<CR>
      nnoremap <silent> ;i  <cmd>lua vim.lsp.buf.implementation()<CR>
      nnoremap <silent> ;s  <cmd>lua vim.lsp.buf.signature_help()<CR>
      nnoremap <silent> ;td <cmd>lua vim.lsp.buf.type_definition()<CR>
    if &filetype ==# 'rust'
        lua require'nvim_lsp'.rust_analyzer.setup{}
    elseif &filetype ==# 'python'
        lua require'nvim_lsp'.pyls_ms.setup{ log_level = 2 }
    endif
    setlocal omnifunc=v:lua.vim.lsp.omnifunc
endfunction
