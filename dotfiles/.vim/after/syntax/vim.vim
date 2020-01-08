" ====================================================
" Filename:    after/syntax/vim.vim
" Description: Vim syntax overrides
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-07
" ====================================================

silent! call syntax#enable_code_snip('python' ,'\"{{{py' ,'\"py}}}', 'SpecialComment')
setlocal foldexpr=VimFoldLevel(v:lnum)

" Simplified version of
" https://vi.stackexchange.com/questions/3814/is-there-a-best-practice-to-fold-a-vimrc-file
function! VimFoldLevel(lnum)
    " Fold functions
    if match(getline(a:lnum), '^[[:space:]]*fun') >= 0
        return '>1'
    endif
    return '='
endfunction
