" General settings {{{1
let g:clap_preview_direction = 'UD'
let g:clap_multi_selection_warning_silent = 1
let g:clap_enable_icon = v:true
let g:clap_preview_size = 10
let g:clap_enable_background_shadow = v:true
let g:clap_background_shadow_blend = 50
let g:clap_layout = {'relative': 'editor'}


" Filters {{{2
let g:ClapProviderHistoryCustomFilter = {s -> s !~? '/doc/.*\.txt$'}

" Commands {{{2
command Task    Clap task
command Filer   Clap filer
command Base16  call plugins#clap#base16()
command Globals Clap globals

" Abbreviations {{{2
call map#cabbr('mapn', 'Clap map ++mode=n')
call map#cabbr('mapi', 'Clap map ++mode=i')
call map#cabbr('mapv', 'Clap map ++mode=v')
call map#cabbr('mapo', 'Clap map ++mode=o')
call map#cabbr('mapx', 'Clap map ++mode=x')
call map#cabbr('scr',  'Clap scriptnames')

" Maps {{{2
nnoremap <F6>      <Cmd>Clap task<CR>
nnoremap <Leader>t <Cmd>Clap tags nvim_lsp<CR>
nnoremap <Leader>h <Cmd>Clap command_history<CR>

" Functions {{{1
function s:get_last_column(str) abort " :: Split string by \s and get last element {{{2
    return split(a:str, ' ')[-1]
endfunction

function plugins#clap#get_selected() abort " :: Get last column from selection {{{2
    return s:get_last_column(g:clap.display.getcurline())
endfunction

function plugins#clap#file_preview() abort " :: Preview current line {{{2
    let l:curline = plugins#clap#get_selected()
    return clap#preview#file(l:curline)
endfunction

function plugins#clap#file_preview_async() abort " :: Preview all lines in background {{{2
    let l:curline = plugins#clap#get_selected()
    return clap#client#call_preview_file({'fpath': l:curline})
endfunction

function plugins#clap#file_edit(sel) abort " :: Edit current selection {{{2
    execute 'edit' s:get_last_column(a:sel)
endfunction

function plugins#clap#base16() abort " :: Theme select {{{2
    let g:clap_enable_background_shadow = v:false
    Clap base16
endfunction

" history (lua/Viml test) {{{1
function plugins#clap#history() abort "{{{2
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
