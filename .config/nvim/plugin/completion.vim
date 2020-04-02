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
    \    'yaml',
    \    'yaml.ansible',
    \ ],
    \ 'none': [
    \    'help',
    \    'nerdtree',
    \    'coc-explorer',
    \    'defx',
    \    'netrw',
    \ ]
    \ }

let g:completion_handler_fts = []
function! s:completion_handler(ft) abort
    let l:comptype = completion#get_type(a:ft)
    let g:completion_handler_fts += [{'ft': a:ft, 'comptype': l:comptype}]
    if l:comptype ==# 'coc'
        packadd coc.nvim
    elseif l:comptype ==# 'nvim-lsp'
        call plugins#nvim_lsp#init()
        packadd vim-mucomplete
        packadd ultisnips
    elseif l:comptype ==# 'mucomplete'
        packadd vim-mucomplete
        packadd ultisnips
    endif
endfunction

augroup plugin_completion
    autocmd!
    autocmd FileType * ++nested call s:completion_handler(expand('<amatch>'))
    autocmd User CocNvimInit ++once call plugins#coc#init()
    " Disable folding on floating windows (coc-git chunk diff)
    autocmd User CocOpenFloat if exists('w:float') | setl nofoldenable | endif
    autocmd BufWinEnter * if exists('w:clap_search_hl_id') | setl nofoldenable | endif
    " autocmd FileType chordpro ++nested packadd vim-mucomplete
augroup END
