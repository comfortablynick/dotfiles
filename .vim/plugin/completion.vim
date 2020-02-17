" ====================================================
" Filename:    plugin/completion.vim
" Description: Autocompletion plugin handling
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-16 15:00:23 CST
" ====================================================
if exists('g:loaded_plugin_completion') | finish | endif
let g:loaded_plugin_completion = 1

let g:completion_filetypes = {
    \ 'coc': [
    \    'c',
    \    'cpp',
    \    'fish',
    \    'go',
    \    'rust',
    \    'typescript',
    \    'javascript',
    \    'json',
    \    'lua',
    \    'bash',
    \    'sh',
    \    'vim',
    \    'yaml',
    \    'snippets',
    \    'toml',
    \    'mail',
    \    'pro',
    \    'ini',
    \    'muttrc',
    \    'cmake',
    \    'zig',
    \    'zsh',
    \ ],
    \ 'nvim-lsp': [
    \    'python',
    \ ],
    \ 'none': [
    \    'txt',
    \    'markdown',
    \    'nerdtree',
    \    'coc-explorer',
    \    'defx',
    \    'netrw',
    \ ]
    \ }

function s:pyls() abort
    packadd nvim-lsp
lua << EOF
    local lsp = require'nvim_lsp'
    lsp["pyls_ms"].setup{ log_level = 2 }
    lsp["pyls_ms"].manager.try_add()
EOF
    setlocal omnifunc=v:lua.vim.lsp.omnifunc
endfunction

augroup plugin_completion
    autocmd!
    autocmd FileType * if completion#get_type(&ft) ==# 'coc'
        \ | silent! packadd coc.nvim
        \ | elseif completion#get_type(&ft) ==# 'nvim-lsp'
        \ | call plugins#nvim_lsp#init()
        \ | endif
    autocmd User CocNvimInit ++once call plugins#coc#init()
    " Disable folding on floating windows (coc-git chunk diff)
    autocmd User CocOpenFloat if exists('w:float') | setl nofoldenable | endif
augroup END
