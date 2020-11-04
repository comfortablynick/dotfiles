" Frequently used commands {{{2
let s:cmds = {
    \ 'ALEInfo': 'ALE debugging info',
    \ 'CocConfig': 'Coc configuration',
    \ 'Scriptnames': 'Runtime scripts sourced',
    \ }
let s:cmd = {}

let s:cmd.source = keys(s:cmds)

function! s:cmd.on_move()
    let l:curline = g:clap.display.getcurline()
    call g:clap.preview.show([s:cmds[l:curline]])
endfunction

let s:cmd.sink = {v-> execute(v, '')}

let g:clap#provider#quick_cmd# = s:cmd
