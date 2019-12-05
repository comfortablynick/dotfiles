if exists('g:loaded_plugin_config_nvim_lsp_d5gcrfhu') | finish | endif
let g:loaded_plugin_config_nvim_lsp_d5gcrfhu = 1

" Call func to set autocmds if LC is loaded
augroup nvim_lsp_config
    autocmd!
    autocmd FileType *
        \ if exists('g:completion_filetypes') &&
        \ index(g:completion_filetypes['nvim-lsp'], &filetype) >= 0
        \ | call Nvim_lsp_init()
        \ | endif
augroup END

function Nvim_lsp_init() abort
    " TODO: add filetype configs here
    packadd nvim-lsp
    " call nvim_lsp#setup('tsserver', {})
    call nvim_lsp#setup('pyls', {})
    setlocal omnifunc=lsp#omnifunc
endfunction
