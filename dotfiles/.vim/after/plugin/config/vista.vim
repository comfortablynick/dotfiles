scriptencoding utf-8
if exists('g:loaded_vista_config_vim') || !exists(':Vista')
    finish
endif
let g:loaded_vista_config_vim = 1

" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ['▸ ', '']
let g:vista_icon_indent = ['╰─▸ ', '├─▸ ']

let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\    'func': 'ƒ',
\    'function': 'ƒ',
\    'var': 'ʋ',
\    'variable': 'ʋ',
\    'const': 'c',
\    'constant': 'c',
\    'method': '𝑚',
\    'package': 'p',
\    'packages': 'p',
\    'enum': 'e',
\    'enumerator': 'e',
\    'module': 'M',
\    'modules': 'M',
\    'type': '𝑡',
\    'typedef': '𝑡',
\    'types': '𝑡',
\    'field': 'f',
\    'fields': 'f',
\    'macro': 'ɱ',
\    'macros': 'ɱ',
\    'map': '⇶',
\    'class': 'c',
\    'augroup': 'a',
\    'struct': 's',
\    'union': 'u',
\    'member': 'm',
\    'target': 't',
\    'property': 'p',
\    'interface': 'I',
\    'namespace': 'n',
\    'subroutine': 'ƒ',
\    'implementation': 'I',
\    'typeParameter': '𝑡',
\    'default': 'd',
\}
let g:vista_close_on_jump = 0

nnoremap <silent> <Leader>v :Vista!!<CR>
"autocmd vimrc VimEnter * if exists(':Vista')
    "\ | call vista#RunForNearestMethodOrFunction() | endif
