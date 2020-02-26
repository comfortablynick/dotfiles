" ====================================================
" Filename:    plugin/completion.vim
" Description: Autocompletion plugin handling
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-24 18:53:47 CST
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
    \    'mail',
    \    'cmake',
    \ ],
    \ 'nvim-lsp': [
    \    'python',
    \ ],
    \ 'mucomplete': [
    \    'asciidoctor',
    \    'markdown',
    \    'just',
    \    'zig',
    \    'zsh',
    \    'muttrc',
    \    'ini',
    \    'mail',
    \    'pro',
    \    'toml',
    \    'vifm',
    \ ],
    \ 'none': [
    \    'help',
    \    'nerdtree',
    \    'coc-explorer',
    \    'defx',
    \    'netrw',
    \ ]
    \ }

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
    autocmd BufWinEnter * if exists('w:clap_search_hl_id') | setl nofoldenable | endif
augroup END
