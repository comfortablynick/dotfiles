" Search help tags and open help tab
let s:help = {}

function! s:help.source()
    let l:lst = []
    for l:rtp in split(&runtimepath, ',')
        let l:path = glob(l:rtp.'/'.'doc/tags')
        if filereadable(l:path)
            let l:tags = map(readfile(l:path), {_,v-> split(v)[0]})
            call extend(l:lst, l:tags)
        endif
    endfor
    return l:lst
endfunction

let s:help.on_enter = {-> g:clap.display.setbufvar('&ft', 'clap_help')}
let s:help.sink = {v-> execute(window#tab_mod('h', 'help').' '.v)}
let g:clap#provider#help# = s:help
