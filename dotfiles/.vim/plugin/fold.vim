" ====================================================
" Filename:    plugin/fold.vim
" Description: Fold-related operations
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-27 19:11:01 CST
" ====================================================
if exists('g:loaded_plugin_fold_xhmvdtqd') | finish | endif
let g:loaded_plugin_fold_xhmvdtqd = 1

nnoremap <silent><Space> :silent! exe 'normal! za'<CR>
nnoremap <silent>za zA

" Customized version of folded text, idea by
" https://github.com/chrisbra/vim_dotfiles/blob/master/plugin/CustomFoldText.vim
function! CustomFoldText(string) abort
    "get first non-blank line
    let fs = v:foldstart
    if getline(fs) =~? '^\s*$'
        let fs = nextnonblank(fs + 1)
    endif
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
    endif
    let g:pat  = matchstr(&l:cms, '^\V\.\{-}\ze%s\m')
    " remove leading comments from line
    let line = substitute(line, '^\s*'.g:pat.'\s*', '', '')
    " remove foldmarker from line
    let g:pat  = '\%('. g:pat. '\)\?\s*'.split(&l:fmr, ',')[0].'\s*\d*'
    let line = substitute(line, g:pat, '', '')
    let w = luaeval('require("window").get_usable_width()')
    let foldSize = 1 + v:foldend - v:foldstart
    let foldSizeStr = ' '.foldSize.' lines '
    let foldLevelStr = '+'.v:folddashes
    let lineCount = line('$')
    if has('float')
        try
            let foldPercentage = printf('[%.1f', (foldSize*1.0)/lineCount*100) . '%] '
        catch /^Vim\%((\a\+)\)\=:E806/	" E806: Using Float as String
            let foldPercentage = printf('[of %d lines] ', lineCount)
        endtry
    endif
    if exists('*strwdith')
        let expansionString = repeat(a:string, w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
    else
        let expansionString = repeat(a:string, w - strlen(substitute(foldSizeStr.line.foldLevelStr.foldPercentage, '.', 'x', 'g')))
    endif
    return line.expansionString.foldSizeStr.foldPercentage.foldLevelStr
endfunction

set foldtext=CustomFoldText('.')
