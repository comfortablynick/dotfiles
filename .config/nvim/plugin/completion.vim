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
    \    'jsonc',
    \    'bash',
    \    'sh',
    \    'python',
    \ ],
    \ 'nvim-lsp': [
    \    'lua',
    \    'vim',
    \ ],
    \ 'complete-nvim': [
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
    \    'ps1',
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

" Get completion type for a filetype, or empty string
function! s:get_completion_type(ftype) abort
    let l:types = get(g:, 'completion_filetypes', {})
    for l:key in keys(l:types)
        for l:val in l:types[l:key]
            if l:val ==? a:ftype
                return l:key
            endif
        endfor
    endfor
    return ''
endfunction

let g:completion_handler_fts = []

function! s:completion_handler(ft) abort
    let g:completion_type = s:get_completion_type(a:ft)
    let g:completion_handler_fts += [{'ft': a:ft, 'comptype': g:completion_type}]
    if g:completion_type ==# 'coc'
        packadd coc.nvim
    elseif g:completion_type ==# 'nvim-lsp'
        packadd vim-gitgutter
        packadd completion-nvim
        packadd completion-buffers
        " packadd ultisnips
        packadd snippets.nvim
    elseif g:completion_type ==# 'mucomplete'
        packadd vim-gitgutter
        packadd vim-mucomplete
        packadd ultisnips
    elseif g:completion_type ==# 'complete-nvim'
        packadd vim-gitgutter
        packadd completion-nvim
        packadd completion-buffers
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
augroup END
