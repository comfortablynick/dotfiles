" coc.nvim source for chordpro
" See https://github.com/neoclide/coc.nvim/wiki/Create-custom-source
function! coc#source#chords#init() abort
    return {
        \ 'filetypes': ['chordpro'],
        \ 'priority': 9,
        \ 'shortcut': 'Chord',
        \ 'triggerCharacters': ['[']
        \}
endfunction

function! coc#source#chords#complete(opt, cb) abort
    let l:items = ['[A]', '[Am]', '[G7/A]']
    call a:cb(l:items)
endfunction
