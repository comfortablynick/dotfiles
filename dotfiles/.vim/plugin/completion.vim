" ====================================================
" Filename:    plugin/completion.vim
" Description: Autocompletion plugin handling
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-01 17:02:15 CST
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
    \    'python',
    \    'bash',
    \    'sh',
    \    'vim',
    \    'yaml',
    \    'snippets',
    \    'markdown',
    \    'toml',
    \    'txt',
    \    'mail',
    \    'pro',
    \    'ini',
    \    'muttrc',
    \    'cmake',
    \    'zig',
    \    'zsh',
    \ ],
    \ 'nvim-lsp': [
    \ ],
    \ 'none': [
    \    'nerdtree',
    \ ]
    \ }

augroup plugin_completion
    autocmd!
    if !empty(g:completion_filetypes.coc)
        autocmd FileType * if index(g:completion_filetypes.coc, &ft) > -1
            \ | call completion#coc()
            \ | endif
        autocmd User CocNvimInit ++once call completion#coc_init()
        " Disable folding on floating windows (coc-git chunk diff)
        autocmd User CocOpenFloat if exists('w:float') | setl nofoldenable | endif
    endif
augroup END
