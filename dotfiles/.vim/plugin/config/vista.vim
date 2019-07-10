scriptencoding utf-8
if exists('g:loaded_vista_config_vim')
    finish
endif
let g:loaded_vista_config_vim = 1

" Calculate fzf preview width based on window width
function s:vista_fzf_preview_width() abort
    let winwidth = winwidth(0)
    let pwidth = 50
    if winwidth < 200
        let pwidth = 60 - (200 - winwidth)
    endif
    return insert([], printf('right:%d%%', pwidth < 0 ? 0 : pwidth))
endfunction

if exists('*nvim_open_win') || exists('*popup_create')
    let g:vista_echo_cursor_strategy = 'floating_win'
else
    let g:vista_echo_cursor_strategy = 'echo'
endif

let g:vista#renderer#enable_icon = 1
let g:vista_close_on_jump = 0
let g:vista_fzf_preview = s:vista_fzf_preview_width()
let g:vista_disable_statusline = exists('g:loaded_airline') || exists('g:loaded_lightline') || exists('g:loaded_eleline')
let g:vista_sidebar_width = winwidth(0) > 200 ? 60 : 40

" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ['▸ ', '']
" let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']
" let g:vista_icon_indent = ['▸ ', '']

" Set default service for filetypes to override ctags
" let g:vista_executive_for = {
"   \ 'cpp': 'coc',
"   \ 'c': 'coc',
"   \ 'rust': 'coc',
"   \ 'json': 'coc',
"   \ 'go': 'coc',
"   \ 'javascript': 'coc',
"   \ 'typescript': 'coc',
"   \ 'sh': 'coc',
"   \ 'bash': 'coc',
"   \ }

" Using this seems to mess up syntax highlighting in the vista window
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

nnoremap <silent> <Leader>v :Vista!!<CR>
nnoremap <silent> <Leader>m :Vista finder<CR>
