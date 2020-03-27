if exists('g:loaded_autoload_plugins_vista') | finish | endif
let g:loaded_autoload_plugins_vista = 1
scriptencoding utf-8

function! s:vista_fzf_preview_width(basewidth) abort
    let l:winwidth = winwidth(0)
    let l:pwidth = a:basewidth
    if l:winwidth < 225
        let l:pwidth = a:basewidth - (200 - l:winwidth)
    endif
    return insert([], printf('right:%d%%', l:pwidth < 0 ? 0 : l:pwidth))
endfunction

function! plugins#vista#post() abort
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
    let g:vista#renderer#enable_icon = 1
    let g:vista_close_on_jump = 1
    let g:vista_disable_statusline = exists('g:loaded_airline')
        \ || exists('g:loaded_lightline')
        \ || exists('g:loaded_eleline')
    let g:vista_sidebar_width = winwidth(0) > 200 ? 60 : 50

    nnoremap <silent><Leader>v :Vista!!<CR>
endfunction

" Icons {{{
" Using this seems to mess up syntax highlighting in the vista window

" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ['▸ ', '']
" let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']
" let g:vista_icon_indent = ['▸ ', '']
" let g:vista#renderer#icons = {
" \    'func': 'ƒ',
" \    'function': 'ƒ',
" \    'var': 'ʋ',
" \    'variable': 'ʋ',
" \    'const': 'c',
" \    'constant': 'c',
" \    'method': '𝑚',
" \    'package': 'p',
" \    'packages': 'p',
" \    'enum': 'e',
" \    'enumerator': 'e',
" \    'module': 'M',
" \    'modules': 'M',
" \    'type': '𝑡',
" \    'typedef': '𝑡',
" \    'types': '𝑡',
" \    'field': 'f',
" \    'fields': 'f',
" \    'macro': 'ɱ',
" \    'macros': 'ɱ',
" \    'map': '⇶',
" \    'class': 'c',
" \    'augroup': 'a',
" \    'struct': 's',
" \    'union': 'u',
" \    'member': 'm',
" \    'target': 't',
" \    'property': 'p',
" \    'interface': 'I',
" \    'namespace': 'n',
" \    'subroutine': 'ƒ',
" \    'implementation': 'I',
" \    'typeParameter': '𝑡',
" \    'default': 'd',
" \}
" }}}
