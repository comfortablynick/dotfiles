" Custom formatter definition for fish scripts

function! neoformat#formatters#fish#enabled() abort
    return ['fish_indent']
endfunction

function! neoformat#formatters#fish#fish_indent() abort
    return {
        \ 'exe': 'fish_indent',
        \ 'args': [],
        \ 'stdin': 1
        \ }
endfunction
