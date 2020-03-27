" ====================================================
" Filename:    plugin/fold.vim
" Description: Fold-related operations
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_plugin_fold' | if exists(s:guard) | finish | endif
let {s:guard} = 1

nnoremap <silent><Space> :silent! exe 'normal! za'<CR>
nnoremap <silent>za zA

" Customized version of folded text, idea by
" https://github.com/chrisbra/vim_dotfiles/blob/master/plugin/CustomFoldText.vim
function! CustomFoldText(string) abort
    "get first non-blank line
    let l:fs = v:foldstart
    if getline(l:fs) =~? '^\s*$'
        let l:fs = nextnonblank(l:fs + 1)
    endif
    if l:fs > v:foldend
        let l:line = getline(v:foldstart)
    else
        let l:line = substitute(getline(l:fs), '\t', repeat(' ', &tabstop), 'g')
    endif
    let g:pat  = matchstr(&l:cms, '^\V\.\{-}\ze%s\m')
    " remove leading comments from line
    let l:line = substitute(l:line, '^\s*'.g:pat.'\s*', '', '')
    " remove foldmarker from line
    let g:pat  = '\%('. g:pat. '\)\?\s*'.split(&l:fmr, ',')[0].'\s*\d*'
    let l:line = substitute(l:line, g:pat, '', '')
    " Get actual width of window
    let l:w = window#width()
    let l:fold_size = 1 + v:foldend - v:foldstart
    let l:fold_size_str = ' '.l:fold_size.' lines '
    let l:fold_level_str = '+'.v:folddashes
    let l:line_ct = line('$')
    if has('float')
        try
            let l:fold_pct = printf('[%.1f', (l:fold_size*1.0)/l:line_ct*100) . '%] '
        catch /^Vim\%((\a\+)\)\=:E806/	" E806: Using Float as String
            let l:fold_pct = printf('[of %d lines] ', l:line_ct)
        endtry
    endif
    if exists('*strwdith')
        let l:expansion_str = repeat(a:string, l:w -
            \ strwidth(l:fold_size_str.l:line.l:fold_level_str.l:fold_pct))
    else
        let l:expansion_str = repeat(a:string, l:w - 
            \ strlen(substitute(l:fold_size_str.l:line.l:fold_level_str.l:fold_pct, '.', 'x', 'g')))
    endif
    return l:line.l:expansion_str.l:fold_size_str.l:fold_pct.l:fold_level_str
endfunction

set foldtext=CustomFoldText('.')
