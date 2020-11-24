" In/around number
" From: https://vimways.org/2018/transactions-pending/

" This can handle the following three formats (so long as s:regNums is
" defined as it should be above these functions):
"   1. binary  (eg: "0b1010", "0b0000", etc)
"   2. hex     (eg: "0xffff", "0x0000", "0x10af", etc)
"   3. decimal (eg: "0", "0000", "10", "01", etc)
" NOTE: if there is no number on the rest of the line starting at the
"       current cursor position, then visual selection mode is ended (if
"       called via an omap) or nothing is selected (if called via xmap);
"       this is true even if on the space following a number

" regular expressions that match numbers (order matters .. keep '\d' last!)
" note: \+ will be appended to the end of each
let s:regNums = ['0b[01]', '0x\x', '\d']

function s:inNumber()
    let l:magic = &magic
    set magic

    let l:lineNr = line('.')
    let l:pat = join(s:regNums, '\+\|') . '\+'
    if !search(l:pat, 'ce', l:lineNr) | return | endif
    normal! v
    call search(l:pat, 'cb', l:lineNr)
    let &magic = l:magic
endfunction

function s:aroundNumber()
    let l:magic = &magic
    set magic

    let l:lineNr = line('.')
    let l:pat = join(s:regNums, '\+\|')..'\+'
    if !search(l:pat, 'ce', l:lineNr) | return | endif
    call search('\%'..(virtcol('.')+1)..'v\s*', 'ce', l:lineNr)
    normal! v
    call search(l:pat, 'cb', l:lineNr)
    call search('\s*\%'..virtcol('.')..'v', 'b', l:lineNr)
    let &magic = l:magic
endfunction

" in number (next number after cursor on current line)
xnoremap <silent> in :<C-U>call <SID>inNumber()<CR>
onoremap <silent> in :<C-U>call <SID>inNumber()<CR>
" around number (next number on line and possible surrounding white-space)
xnoremap <silent> an :<C-U>call <SID>aroundNumber()<CR>
onoremap <silent> an :<C-U>call <SID>aroundNumber()<CR>
