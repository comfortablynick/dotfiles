scriptencoding utf-8
" ====================================================
" Filename:    plugin/statusline.vim
" Description: Custom statusline
" Author:      Nick Murphy
"              (adapted from code from Kabbaj Amine
"               - amine.kabb@gmail.com)
" License:     MIT
" Last Change: 2020-02-25 17:15:59 CST
" ====================================================
if exists('g:loaded_plugin_statusline') || exists('*lightline#update') | finish | endif
let g:loaded_plugin_statusline = 1

" Variables {{{1
" Use lua {{{2
" lua require'lightline'
" lua ll.init()
" finish

" General {{{2
let g:devicons = $MOSH_CONNECTION ? 0 : 1

" g:sl :: statusline variables {{{2
let g:sl  = {
    \ 'width': {
    \     'min': 90,
    \     'med': 140,
    \     'max': 200,
    \ },
    \ 'separator': '┊',
    \ 'symbol': {
    \     'buffer': '❖',
    \     'branch': '',
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

function! s:def(fn, hl) abort "{{{2
    return printf('%%#%s#%%{%s()}%%*', a:hl, a:fn)
endfunction

" SL command {{{2
command! -nargs=? -complete=custom,statusline#sl_complete_args SL
    \ call statusline#sl_command(<f-args>)

" Statusline definition {{{1
" Custom highlights {{{2
" let g:statusline_hi = statusline#get_highlight('StatusLine')
"
" highlight IsModified guibg=#5f8787 ctermbg=66 ctermfg=160 guifg=#f01d22 gui=bold cterm=bold
" highlight User1 guibg=#5f8787 ctermbg=66 guifg=#1c1c1c ctermfg=234 gui=italic,bold cterm=italic,bold

" call statusline#set_highlight(
"     \ 'IsModified',
"     \ [get(g:statusline_hi, 'guifg'), get(g:statusline_hi, 'ctermfg')],
"     \ ['Red', 'Red'],
"     \ '',
"     \ )


function! s:set_statusline() abort "{{{2
    set statusline=
    set ruler
    return
    if statusline#is_not_file() | return | endif

    set statusline+=%(%{&buflisted?'['.bufnr('%').']':''}\ %)
    set statusline+=%<
    set statusline+=%(\ %h%w%)
    set statusline+=%(\ %{statusline#file_name()}%)
    set statusline+=%(\ %m%r%)
    " set statusline+=%(\ %{&readonly?g:sl.symbol.readonly:''}%)
    " set statusline+=%(\ %{statusline#modified()}%)
    set statusline+=%(\ \ %{statusline#linter_errors()}%)
    set statusline+=%(\ %{statusline#linter_warnings()}%)

    set statusline+=%=
    set statusline+=%(\ %{statusline#toggled()}\ ┊%)
    set statusline+=%(\ %{statusline#job_status()}\ ┊%)
    set statusline+=%(\ %{statusline#coc_status()}\ ┊%)
    set statusline+=%(\ %{statusline#git_status()}\ ┊%)
    set statusline+=%(\ %l,%c%)\ %4(%p%%%)
    " set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
endfunction


function! Status(winnr) abort "{{{2
    let l:active = a:winnr == winnr()
    let l:bufnr = winbufnr(a:winnr)

    " Utils to pad if not empty
    let l:Lpad = {s->!empty(s) ? ' '.s : ''}
    let l:Rpad = {s->!empty(s) ? s.' ' : ''}

    let l:status = ''
    if statusline#is_not_file(l:bufnr) || !l:active
        return l:status
    endif

    let l:status .= l:Lpad(statusline#bufnr(l:bufnr))
    let l:status .= '%<'
    let l:status .= l:Lpad(statusline#file_name(l:bufnr))
    " set statusline+=%(\ %h%w%)
    " set statusline+=%(\ %{statusline#file_name()}%)
    " set statusline+=%(\ %m%r%)
    " set statusline+=%(\ \ %{statusline#linter_errors()}%)
    " set statusline+=%(\ %{statusline#linter_warnings()}%)
    "
    " set statusline+=%=
    " set statusline+=%(\ %{statusline#toggled()}\ ┊%)
    " set statusline+=%(\ %{statusline#job_status()}\ ┊%)
    " set statusline+=%(\ %{statusline#coc_status()}\ ┊%)
    " set statusline+=%(\ %{statusline#git_status()}\ ┊%)
    " set statusline+=%(\ %l,%c%)\ %4(%p%%%)
    return l:status
endfunction

" Refresh statusline {{{2
function! s:refresh_status() abort
    for l:win in range(1, winnr('$'))
        " call setwinvar(l:win, '&statusline', '%!Status('. l:win .')')
        call setwinvar(l:win, '&statusline', Status(l:win))
    endfor
endfunction

augroup plugin_statusline
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * call s:refresh_status()
    autocmd WinClosed * call s:refresh_status()
augroup END

" Old statusline code {{{1
finish
" General {{{2
function! SL_bufnr() abort " {{{3
    let bufnr = bufnr('%')
    let nums = [
        \ "\u24ea",
        \ "\u2460",
        \ "\u2461",
        \ "\u2462",
        \ "\u2463",
        \ "\u2464",
        \ "\u2465",
        \ "\u2466",
        \ "\u2467",
        \ "\u2468",
        \ "\u2469",
        \ "\u2470",
        \]
    return len(nums) < bufnr ?
        \ '['.bufnr.']' :
        \ ' '.get(nums, bufnr('%'), bufnr('%')).' '
endfunction

function! SL_path() abort " {{{3
    if !empty(expand('%:t'))
        let fn = winwidth(0) <# 55
            \ ? '../'
            \ : winwidth(0) ># 85
            \ ? expand('%:~:.:h') . '/'
            \ : pathshorten(expand('%:~:.:h')) . '/'
    else
        let fn = ''
    endif
    return fn
endfunction

function! SL_previewwindow() abort " {{{3
    return &previewwindow ? '[Prev]' : ''
endfunction

function! SL_filename() abort " {{{3
    let fn = !empty(expand('%:t'))
        \ ? expand('%:p:t')
        \ : '[No Name]'
    return fn . (&readonly ? ' ' : '')
endfunction

function! SL_modified() abort " {{{3
    return &modified ? g:sl.symbol.modified : ''
endfunction

function! SL_format_and_encoding() abort " {{{3
    let encoding = winwidth(0) < g:sl.width.min
        \ ? ''
        \ : strlen(&fileencoding)
        \ ? &fileencoding
        \ : &encoding
    let format = winwidth(0) > g:sl.width.med
        \ ? &fileformat
        \ : winwidth(0) < g:sl.width.min
        \ ? ''
        \ : &fileformat[0]
    return printf('%s[%s]', encoding, format)
endfunction

function! SL_filetype() abort " {{{3
    return strlen(&filetype) ? &filetype : ''
endfunction

function! SL_hi_group() abort " {{{3
    return '> ' . synIDattr(synID(line('.'), col('.'), 1), 'name') . ' <'
endfunction

function! SL_paste() abort " {{{3
    if &paste
        return winwidth(0) <# 55 ? '[P]' : '[PASTE]'
    else
        return ''
    endif
endfunction

function! SL_spell() abort " {{{3
    return &spell ? &spelllang : ''
endfunction

function! SL_indentation() abort " {{{3
    return winwidth(0) <# 55
        \ ? ''
        \ : &expandtab
        \ ? 's:' . &shiftwidth
        \ : 't:' . &shiftwidth
endfunction

function! SL_column_and_percent() abort " {{{3
    " The percent part was inspired by vim-line-no-indicator plugin.
    let chars = ['꜒', '꜓', '꜔', '꜕', '꜖',]
    let [c_l, l_l] = [line('.'), line('$')]
    let index = float2nr(ceil((c_l * len(chars) * 1.0) / l_l)) - 1
    let perc = chars[index]
    return winwidth(0) ># 55 ? printf('%s%2d', perc, col('.')) : ''
endfunction

function! SL_jobs() abort " {{{3
    let n_jobs = exists('g:jobs') ? len(g:jobs) : 0
    return winwidth(0) <# 55
        \ ? ''
        \ : n_jobs
        \ ? ' ' . n_jobs
        \ : ''
endfunction

function! SL_toggled() abort " {{{3
    if !exists('g:SL_toggle')
        return ''
    endif
    let sl = ''
    for [k, v] in items(g:SL_toggle)
        let str = call(v, [])
        let sl .= empty(sl)
            \ ? str . ' '
            \ : g:sl.separator . ' ' . str . ' '
    endfor
    return sl[:-2]
endfunction

function! SL_terminal() abort " {{{3
    let term_buf_nr = get(g:, 'term_buf_nr', 0)
    return term_buf_nr && index(term_list(), term_buf_nr) != -1
        \ ? '' : ''
endfunction

function! SL_qf() abort " {{{3
    return printf('[q:%d l:%d]',
        \ len(getqflist()),
        \ len(getloclist(bufnr('%')))
        \ )
endfunction

function! SL_diagnostic(mode) abort " {{{3
    let coc = SL_coc_diagnostic(a:mode)
    let ale = SL_ale(a:mode)
    let errors = coc[0] + ale[0]
    let warnings = coc[1] + ale[1]
    return g:sl_get_parsed_linting_str(errors, warnings, a:mode)
endfunction

" Plugin interfaces {{{2
function! SL_fugitive() abort " {{{3
    if winwidth(0) < g:sl.width.min | return '' | endif
    if !exists('*FugitiveHead') | return '' | endif
    let icon = g:sl.symbol.branch
    let head = FugitiveHead()
    return head !=# 'master' ? icon.' '.head : icon
endfunction

function! SL_signify() abort " {{{3
    if exists('*sy#repo#get_stats')
        let h = sy#repo#get_stats()
        return h !=# [-1, -1, -1] && winwidth(0) > g:sl.width.min && h !=# [0, 0, 0]
            \ ? printf('+%d ~%d -%d', h[0], h[1], h[2])
            \ : ''
    else
        return ''
    endif
endfunction

function! SL_git_hunks() abort "{{{3
    " Look for status in this order
    " 1. coc-git, 2. gitgutter, 3. signify
    if exists('b:coc_git_status') | return trim(b:coc_git_status) | endif
    if exists('*GitGutterGetHunkSummary')
        let githunks = GitGutterGetHunkSummary()
    elseif exists('*sy#repo#get_stats')
        let githunks = sy#repo#get_stats()
    else
        return ''
    endif
    let added   =   githunks[0] ? printf('+%d ', githunks[0])   : ''
    let changed =   githunks[1] ? printf('~%d ', githunks[1])   : ''
    let deleted =   githunks[2] ? printf('-%d ', githunks[2])   : ''
    return added.changed.deleted
endfunction

function! SL_ale(mode) abort " {{{3
    " a:mode: 1/0 = errors/ok
    if get(g:, 'ale_enabled', 0) == 0 | return [0, 0] | endif
    let counts = ale#statusline#Count(bufnr('%'))
    let errors = counts.error + counts.style_error
    let warnings = counts.warning + counts.style_warning
    return [errors, warnings]
endfunction

function! SL_coc_diagnostic(mode) abort " {{{3
    " a:mode: 1/0 = errors/ok
    if get(g:, 'coc_enabled', 0) == 0  || !exists('b:coc_diagnostic_info')
        return [0, 0]
    endif
    let coc = b:coc_diagnostic_info
    let errors = get(coc, 'error', 0)
    let warnings = get(coc, 'warning', 0)
    return [errors, warnings]
endfunction

function! SL_coc_status() abort " {{{3
    let status = get(g:, 'coc_status', '')
    return status
endfunction

" Helpers {{{2
let g:sl_hg = []
function! SL_hi(group, bg, fg, opt) abort " {{{3
    let bg = type(a:bg) == v:t_string ? ['none', 'none' ] : a:bg
    let fg = type(a:fg) == v:t_string ? ['none', 'none'] : a:fg
    let opt = empty(a:opt) ? ['none', 'none'] : [a:opt, a:opt]
    let mode = ['gui', 'cterm']
    let cmd = 'hi '.a:group.' term='.opt[1]
    for i in (range(0, len(mode)-1))
        let cmd .= printf(' %sbg=%s %sfg=%s %s=%s',
            \ mode[i], bg[i],
            \ mode[i], fg[i],
            \ mode[i], opt[i]
            \ )
    endfor
    let g:sl_hg += [cmd]
    execute cmd
endfunction

function! s:set_sl_colors() abort " {{{3
    let statusline = GetHighlight('StatusLine')
    call SL_hi('User1', g:sl.colors['main'], g:sl.colors['background'], 'bold')
    call SL_hi('User2', g:sl.colors['backgroundLight'], g:sl.colors['text'], 'none')
    " call SL_hi('User2', statusline['ctermfg'], statusline)
    call SL_hi('User3', g:sl.colors['backgroundLight'], g:sl.colors['textDark'], 'none')
    call SL_hi('User4', g:sl.colors['main'], g:sl.colors['background'], 'none')

    " Modified state
    call SL_hi('User5', g:sl.colors['backgroundLight'], g:sl.colors['red'], 'bold')

    " Success & error states
    call SL_hi('User6', g:sl.colors['backgroundLight'], g:sl.colors['green'], 'bold')
    call SL_hi('User7', g:sl.colors['backgroundLight'], g:sl.colors['orange'], 'bold')
    " Inactive statusline
    call SL_hi('User8', g:sl.colors['backgroundDark'], g:sl.colors['backgroundLight'], 'none')
endfunction

function! s:set_colors() abort "{{{3
    hi link User3 StatusLine
    hi link User8 StatusLineNC
endfunction

function! s:toggle_sl_item(var, funcref) abort " {{{3
    let g:SL_toggle = get(g:, 'SL_toggle', {})
    if has_key(g:SL_toggle, a:var)
        call remove(g:SL_toggle, a:var)
    else
        let g:SL_toggle[a:var] = a:funcref
    endif
endfunction

function! SL_extract(group, what, ...) abort "{{{3
    if a:0 == 1
        return synIDattr(synIDtrans(hlID(a:group)), a:what, a:1)
    else
        return synIDattr(synIDtrans(hlID(a:group)), a:what)
    endif
endfunction

function! GetHighlight(src) abort "{{{3
    let hl = execute('highlight '.a:src)
    let mregex = '\v(\w+)\=(\S+)'
    let idx = 0
    let arr = {}
    while 1
        let idx = match(hl, mregex, idx)
        if idx == -1
            break
        endif
        let m = matchlist(hl, mregex, idx)
        let idx += len(m[0])
        let arr[m[1]]=m[2]
    endwhile
    return arr
endfunction

function! Get_SL(...) abort " {{{3
    let sl = ''
    " Custom functions
    if has_key(g:sl.apply, &filetype)
        let fun = get(g:sl.apply, &filetype)
        let len_f = len(fun)
        if len_f == 1
            let sl = '%{'.fun[0].'}'
        elseif len_f == 2
            let sl = '%{'.fun[0].'}'
            let sl .= '%=%{'.fun[-1].'}'
        else
            for i in range(0, len_f - 2)
                if exists('*'.fun[i])
                    let sl .= (i != 0 ? g:sl.separator.' ' : '') .
                        \ '%{'.fun[i].'}'
                endif
            endfor
            let sl .= '%=%{'.fun[-1].'}'
        endif
        return sl
    endif

    " Inactive statusline
    if exists('a:1')
        let sl .= '%1*%( %{SL_previewwindow()} %)'
        let sl .= '%8* %{SL_bufnr()} '
        let sl .= '%{SL_path()}'
        let sl .= '%{SL_filename()}'
        let sl .= '%( %{SL_modified()}%)'
        let sl .= '%=%( %{SL_filetype()} %)'
        return sl
    endif

    " Active statusline
    let sl .= '%1*%( %{SL_previewwindow()} %)'
    let sl .= '%( %{SL_paste()} %)'
    let sl .= '%3* %{SL_bufnr()} '
    let sl .= '%{SL_path()}'
    let sl .= '%2*%{SL_filename()}'
    let sl .= '%5*%( %{SL_modified()}%) '

    " or coc (1st group for no errors)
    let sl .= '%6*%(%{SL_diagnostic(0)} %)'
    let sl .= '%7*%(%{SL_diagnostic(1)} %)'

    " coc status
    let sl .= '%2*%( %{SL_coc_status()} %)'
    let sl .= '%3*'

    let sl .= '%='

    " Git
    let sl .= '%( %{SL_git_hunks()} %)'
    let sl .= '%(%{SL_fugitive()} '.g:sl.separator.'%)'

    let sl .= '%( %{SL_spell()} '.g:sl.separator.'%)'
    let sl .= '%( %{SL_filetype()} %)'

    let sl .= '%4*'

    " Toggled elements
    let sl .= '%( %{SL_toggled()} %)'

    " Terminal jobs
    let sl .= '%( %{SL_terminal()} %)'

    " Jobs
    let sl .= '%( %{SL_jobs()} %)'
    return sl
endfunction

function! g:sl_init() abort " {{{3
    set laststatus=2
    call s:set_sl_colors()
    " call s:set_colors()
    call s:apply_sl()
    augroup SL
        autocmd!
        autocmd WinEnter,BufEnter,FocusGained * call <SID>apply_sl()
        autocmd WinLeave,FocusLost * call <SID>apply_sl(1)
        autocmd TermOpen * call <SID>apply_sl()
    augroup END
endfunction

function! s:apply_sl(...) abort " {{{3
    if &buftype ==# 'terminal'
        setlocal statusline&
        set ruler
    elseif index(g:sl.ignore, &filetype) < 0
        if !exists('a:1')
            let &statusline = Get_SL()
        else
            let &statusline = Get_SL(0)
        endif
    else
        setlocal statusline&
    endif
endfunction

function! g:sl_get_parsed_linting_str(errors, warnings, mode) abort " {{{3
    let errors_str = a:errors != 0 ?
        \ printf('%s %s', g:sl.symbol.error_sign, a:errors)
        \ : ''
    let warnings_str = a:warnings != 0 ?
        \ printf('%s %s', g:sl.symbol.warning_sign, a:warnings)
        \ : ''
    let def_str = errors_str.' '.warnings_str

    " Trim spaces
    let def_str = substitute(def_str, '^\s*\(.\{-}\)\s*$', '\1', '')
    let success_str = g:sl.symbol.success_sign

    if a:mode == 1
        return def_str
    else
        return a:errors + a:warnings == 0 ? success_str : ''
    endif
endfunction

" Commands {{{2
" SL {{{3
let s:args = [
    \   ['toggle', 'clear'],
    \   [
    \       'column_and_percent', 'format_and_encoding', 'indentation',
    \       'hi_group', 'qf'
    \   ]
    \ ]
command! -nargs=? -complete=custom,g:sl_complete_args SL
    \ call g:sl_command(<f-args>)

function! g:sl_command(...) abort " {{{3
    let arg = exists('a:1') ? a:1 : 'clear'

    if arg ==# 'toggle'
        let &laststatus = (&laststatus != 0 ? 0 : 2)
        let &showmode = (&laststatus == 0 ? 1 : 0)
        return
    elseif arg ==# 'clear'
        unlet! g:SL_toggle
        return
    endif

    " Split args in case we have many
    let args = split(arg, ' ')

    " Check the 1st one only
    if index(s:args[1], args[0], 0) == -1
        return
    endif

    for a in args
        let fun_ref = 'SL_' . arg
        call s:toggle_sl_item(arg, fun_ref)
    endfor
endfunction

function! g:sl_complete_args(a, l, p) abort " {{{3
    return join(s:args[0] + s:args[1], "\n")
endfunction

" Initialize {{{3
call <SID>sl_init()

" vim:fdl=1:
