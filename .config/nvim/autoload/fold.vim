" Customized version of folded text, idea by
" https://github.com/chrisbra/vim_dotfiles/blob/master/plugin/CustomFoldText.vim
" TODO: enter comment string after end of fn definition, e.g., 'abort'
function fold#CustomFoldText(string)
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
    let l:pat  = matchstr(&l:cms, '^\V\.\{-}\ze%s\m')
    " remove leading comments from line
    let l:line = substitute(l:line, '^\s*'.l:pat.'\s*', '', '')
    " remove foldmarker from line
    let l:pat  = '\%('. l:pat. '\)\?\s*'.split(&l:fmr, ',')[0].'\s*\d*'
    let l:line = substitute(l:line, l:pat, '', '')
    let l:line = trim(join(split(l:line)))
    " Get actual width of window
    let l:w = window#width()
    let l:fold_size = 1 + v:foldend - v:foldstart
    let l:fold_size_str = ' '.l:fold_size.' lines '
    let l:fold_level_str = '+'.v:folddashes
    let l:line_ct = line('$')
    let l:fold_pct = l:fold_size * 1.0 / l:line_ct * 100
    let l:fold_pct_str = printf('[%4.1f%%] ', l:fold_pct)
    let l:expansion_str = repeat(a:string, l:w -
        \ strwidth(l:fold_size_str.l:line.l:fold_level_str.l:fold_pct_str))
    return l:line.l:expansion_str.l:fold_size_str.l:fold_pct_str.l:fold_level_str
endfunction

" set foldtext=fold#CustomFoldText('.')