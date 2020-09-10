let s:guard = 'g:loaded_autoload_plugins_vista' | if exists(s:guard) | finish | endif
let {s:guard} = 1
scriptencoding utf-8

function! s:vista_fzf_preview_width(basewidth) abort
    let l:winwidth = winwidth(0)
    let l:pwidth = a:basewidth
    if l:winwidth < 225
        let l:pwidth = a:basewidth - (200 - l:winwidth)
    endif
    return insert([], printf('right:%d%%', l:pwidth < 0 ? 0 : l:pwidth))
endfunction

let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%'] " s:vista_fzf_preview_width(50)
let g:vista_fzf_opt = [
    \ '-m',
    \ '--bind',
    \     'left:preview-up,'.
    \     'right:preview-down,'.
    \     'ctrl-a:select-all,'.
    \     '?:toggle-preview',
    \ ]
let g:vista_echo_cursor = 1
let g:vista_floating_delay = 1000
let g:vista#renderer#enable_icon = !$MOSH_CONNECTION
let g:vista_close_on_jump = 1
let g:vista_disable_statusline = exists('g:loaded_airline')
    \ || exists('g:loaded_lightline')
    \ || exists('g:loaded_eleline')
let g:vista_sidebar_width = winwidth(0) > 200 ? 60 : 50

nnoremap <silent><Leader>v :Vista!!<CR>
