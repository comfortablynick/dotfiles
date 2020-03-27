" ====================================================
" Filename:    plugin/completion.vim
" Description: Autocompletion plugin handling
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_plugin_completion' | if exists(s:guard) | finish | endif
let {s:guard} = 1

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
    \    'bash',
    \    'sh',
    \    'vim',
    \    'lua',
    \    'yaml',
    \    'yaml.ansible',
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
    \    'chordpro',
    \    'toml',
    \    'vifm',
    \    'snippets',
    \    'cmake',
    \    'mail',
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
        \ | call plugins#coc#preconfig()
        \ | silent! packadd coc.nvim
        \ | elseif completion#get_type(&ft) ==# 'nvim-lsp'
            \ | call plugins#nvim_lsp#init()
            \ | endif
    autocmd User CocNvimInit ++once call plugins#coc#init()
    " Disable folding on floating windows (coc-git chunk diff)
    autocmd User CocOpenFloat if exists('w:float') | setl nofoldenable | endif
    autocmd BufWinEnter * if exists('w:clap_search_hl_id') | setl nofoldenable | endif
augroup END
