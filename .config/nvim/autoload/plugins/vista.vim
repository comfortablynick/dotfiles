function s:vista_fzf_preview_width(basewidth)
    let l:winwidth = winwidth(0)
    let l:pwidth = a:basewidth
    if l:winwidth < 225
        let l:pwidth = a:basewidth - (200 - l:winwidth)
    endif
    return insert([], printf('right:%d%%', l:pwidth < 0 ? 0 : l:pwidth))
endfunction

let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista#executives = has('nvim-0.5') ? ['nvim_lsp', 'ctags'] : ['ctags']
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
let g:vista#renderer#enable_icon = 1
let g:vista_close_on_jump = 0
let g:vista_sidebar_width = winwidth(0) > 200 ? 60 : 50

nnoremap <Leader><Leader>v <Cmd>Vista!!<CR>
