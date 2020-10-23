scriptencoding utf-8

function Chords()
    python3 << EOF
import vim
import re
from collections import Counter

matches = re.findall(r"\[.+?\]", "\n".join(vim.current.buffer[:]))
counter = Counter(matches)
matches = [item[0] for item in counter.most_common()]
EOF
    return py3eval('matches')
endfunction

function CompleteChords(findstart, base)
    if a:findstart
        " locate the start of the word
        let l:line = getline('.')
        let l:start = col('.') - 1
        while l:start > 0 && l:line[l:start - 1] =~? '\a'
            let l:start -= 1
        endwhile
        return l:start
    else
        " find items matching with "a:base"
        let l:res = []
        for l:m in Chords()
            if l:m =~ '^' . a:base
                call add(l:res, l:m)
            endif
        endfor
        return l:res
    endif
endfunction

" Map <C-x><C-m> for our custom completion
inoremap <buffer> <C-x><C-m><C-r>=ChordComplete()<CR>

" Make subsequent <C-m> presses after <C-x><C-m> go to the next entry (just like
" other <C-x>* mappings)
inoremap <buffer> <expr> <C-m>
    \ pumvisible() ?  "\<C-n>" : "\<C-m>"

" Complete function for addresses; we match the name & address
function ChordComplete()
    " The data. In this example it's static, but you could read it from a file,
    " get it from a command, etc.
    let l:data = Chords()

    " Locate the start of the word and store the text we want to match in l:base
    let l:line = getline('.')
    let l:start = col('.') - 1
    while l:start > 0 && l:line[l:start - 1] =~? '\a'
        let l:start -= 1
    endwhile
    let l:base = l:line[l:start : col('.')-1]

    " Record what matches − we pass this to complete() later
    let l:res = []

    " Find matches
    for l:m in l:data
        " Check if it matches what we're trying to complete
        if l:m !~? '^' . l:base
            " Doesn't match
            continue
        endif

        " It matches! See :help complete-items for the full docs on the key names
        " for this dict.
        call add(l:res, {
            \ 'icase': 1,
            \ 'word': l:m,
            \ 'menu': 'chord',
            \ })
    endfor

    " Now call the complete() function
    call complete(l:start, l:res)
    return ''
endfun

setlocal completefunc=CompleteChords
