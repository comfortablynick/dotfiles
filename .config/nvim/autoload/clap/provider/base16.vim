" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Preview lua base16 theme variations

let s:spec = {}

" Favorites:
" darktooth
" mocha
" monokai

let s:base16 = v:lua.require('theme.base16')
let s:config = v:lua.require('config.theme')
let s:start_theme = s:config.base16_theme
let s:last_theme = get(g:, 'last_theme', s:start_theme)

let s:spec.source = {->s:config.themes_after(s:last_theme)}
let s:spec.on_move = {->s:config.set_theme(g:clap.display.getcurline())}

function s:spec.sink(selected)
    if a:selected !=# s:last_theme
        " Theme has changed since we last moved in clap
        call s:config.set_theme(a:selected)
        echo 'Base16 theme changed to '..a:selected
    endif
    let s:last_theme = a:selected
endfunction

function s:spec.on_exit()
    let g:clap_enable_background_shadow = v:true
endfunction

let g:clap#provider#base16# = s:spec
