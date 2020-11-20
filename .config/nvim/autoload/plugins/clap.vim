" Clap setup {{{1
" General settings
let g:clap_multi_selection_warning_silent = 1
let g:clap_enable_icon = 1
let g:clap_preview_size = 10
let g:clap_enable_background_shadow = v:true
let g:clap_background_shadow_blend = 50
let g:clap_layout = #{
    \ relative: 'editor'
    \ }

" Commands 
command Task    Clap task
command Filer   Clap filer
command Base16  call plugins#clap#base16()
Alias t   Clap\ tags
Alias scr Clap\ scriptnames
Alias mru Clap\ mru

" Maps
nnoremap <silent> <Leader>t :Clap tags<CR>
nnoremap <silent> <Leader>h :Clap command_history<CR>
nnoremap <silent> <Leader>m :Clap mru<CR>

" Functions {{{1
" function plugins#clap#get_selected() :: Get selection sans icon {{{2
function plugins#clap#get_selected()
    let l:curline = g:clap.display.getcurline()
    if g:clap_enable_icon
        let l:curline = l:curline[4:]
    endif
    return l:curline
endfunction

" function plugins#clap#file_preview() :: File preview with icon support {{{2
function plugins#clap#file_preview()
    let l:curline = plugins#clap#get_selected()
    return clap#preview#file(l:curline)
endfunction

" function plugins#clap#file_edit() :: File edit with icon support {{{2
function plugins#clap#file_edit(selected)
    let l:fname = g:clap_enable_icon ?
        \ a:selected[4:] :
        \ a:selected
    execute 'edit' l:fname
endfunction

" function plugins#clap#base16() :: theme select {{{1
function plugins#clap#base16()
    let g:clap_enable_background_shadow = v:false
    Clap base16
endfunction

" history (lua/Viml test) {{{1
function plugins#clap#history() "{{{2
    let l:hist = filter(
        \ map(range(1, histnr(':')), {v-> histget(':', - v)}),
        \ {v-> !empty(v)}
        \ )
    let l:cmd_hist_len = len(l:hist)
    return map(l:hist, {k,v-> printf('%4d', l:cmd_hist_len - k)..'  '..v})
endfunction

function plugins#clap#history_lua() "{{{2
    return luaeval('require("tools").get_history_clap()')
endfunction
" vim:fdl=1:
