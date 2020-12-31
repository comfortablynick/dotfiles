scriptencoding utf-8

" Variables {{{
let g:default_statusline = '%<%f %h%m%r'
let g:nf = !$MOSH_CONNECTION
let g:sl  = #{
    \ width: #{
    \     min: 90,
    \     med: 140,
    \     max: 200,
    \ },
    \ sep: '┊',
    \ symbol: #{
    \     buffer       : '❖',
    \     branch       : '',
    \     git-reverse  : '',
    \     git          : '',
    \     line_no      : '',
    \     lines        : '☰',
    \     modified     : '●',
    \     unmodifiable : '-',
    \     readonly     : '',
    \     warning_sign : '‼',
    \     error_sign   : '✘',
    \     hint_sign    : '•',
    \     success_sign : '✓',
    \ },
    \ ignore: [
    \     'pine',
    \     'vfinder',
    \     'qf',
    \     'undotree',
    \     'diff',
    \     'coc-explorer',
    \ ],
    \ }

" }}}

" Set statusline
set statusline=%!statusline#get()

" SL :: toggle statusline items
command! -nargs=? -complete=custom,statusline#complete_args SL call statusline#command(<f-args>)

" The following lines must come after colorscheme declaration
" Remove bold from StatusLine
function! s:set_user_highlights()
    let l:sl = statusline#get_highlight('StatusLine')
    call syntax#derive('StatusLine', 'StatusLine', 'cterm=reverse', 'gui=reverse')
    call syntax#derive('IncSearch', 'User1')
    call syntax#derive('WildMenu', 'User2', 'cterm=NONE', 'gui=NONE')
    call syntax#derive('Visual', 'User3')
    call syntax#derive('DiffDelete', 'User4', 'guibg='..l:sl.guifg)
    call syntax#derive('StatusLine', 'User5', 'guibg=#900c3f', 'gui=reverse,bold')
    call syntax#derive('StatusLine', 'User6', 'guibg=#ecff00', 'gui=reverse,bold')
endfunction

call s:set_user_highlights()

augroup plugin_statusline
    autocmd!
    autocmd ColorScheme * call s:set_user_highlights()
augroup END
