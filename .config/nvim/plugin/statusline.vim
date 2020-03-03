scriptencoding utf-8
" ====================================================
" Filename:    plugin/statusline.vim
" Description: Custom statusline
" Author:      Nick Murphy
"              (adapted from code from Kabbaj Amine
"               - amine.kabb@gmail.com)
" License:     MIT
" Last Change: 2020-03-03 16:10:55 CST
" ====================================================
const s:guard = 'g:loaded_plugin_statusline' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" Variables {{{1
let g:nf = !$MOSH_CONNECTION
let g:sl  = {
    \ 'width': {
    \     'min': 90,
    \     'med': 140,
    \     'max': 200,
    \ },
    \ 'sep': '┊',
    \ 'symbol': {
    \     'buffer': '❖',
    \     'branch': '',
    \     'git': '',
    \     'line_no': '',
    \     'lines': '☰',
    \     'modified': '●',
    \     'unmodifiable': '-',
    \     'readonly': '',
    \     'warning_sign' : '•',
    \     'error_sign'   : '✘',
    \     'success_sign' : '✓',
    \ },
    \ 'ignore': [
    \     'pine',
    \     'vfinder',
    \     'qf',
    \     'undotree',
    \     'diff',
    \     'coc-explorer',
    \ ],
    \ 'apply': {},
    \ 'colors': {
    \     'background'      : ['#2f343f', 'none'],
    \     'backgroundDark'  : ['#191d27', '16'],
    \     'backgroundLight' : ['#464b5b', '59'],
    \     'green'           : ['#2acf2a', '40'],
    \     'orange'          : ['#ff8700', 'none'],
    \     'main'            : ['#5295e2', '68'],
    \     'red'             : ['#f01d22', '160'],
    \     'text'            : ['#cbcbcb', '251'],
    \     'textDark'        : ['#8c8c8c', '244'],
    \ },
    \ }

" Use lua {{{1
lua require'statusline'

" SL command {{{1
command! -nargs=? -complete=custom,statusline#complete_args SL
    \ call statusline#command(<f-args>)

" Autocommands {{{1
augroup plugin_statusline
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * lua sl.refresh()
    " autocmd User ClapOnExit call statusline#refresh()
augroup END

" Highlights {{{1
" The following lines must come after colorscheme declaration
highlight User1 guifg=#ffffff  guibg=#660000
highlight User2 guifg=#ffffff  guibg=#990033
highlight User3 guifg=#ffffff  guibg=#666600
highlight User4 guifg=#ffffff  guibg=#336633
highlight User5 guifg=#ffffff  guibg=#336699
