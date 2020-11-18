" Preview lua base16 theme variations
let s:spec = {}

let s:base16 = v:lua.require('theme.base16')

let s:spec.source = sort(s:base16.theme_names())
let s:spec.on_move = {->s:base16.apply_theme(s:base16.themes[g:clap.display.getcurline()], v:true)}

function s:spec.sink(selected)
    echo 'Base16 theme changed to '..a:selected
endfunction

let g:clap#provider#base16# = s:spec
