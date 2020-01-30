scriptencoding utf-8
" ====================================================
" Filename:    plugin/statusline.vim
" Description: Custom statusline
" Author:      Nick Murphy
"              (adapted from code from Kabbaj Amine
"               - amine.kabb@gmail.com)
" License:     MIT
" Last Change: 2020-01-29 18:42:27 CST
" ====================================================
let g:loaded_plugin_statusline = 1
if exists('g:loaded_plugin_statusline') || exists('*lightline#update')
    finish
endif
let g:loaded_plugin_statusline = 1

" Variables {{{1
let g:devicons = $VIM_SSH_COMPAT ? 0 : 1
" s:sl {{{2
let s:sl  = {
    \ 'width': {
    \     'min': 90,
    \     'med': 140,
    \     'max': 200,
    \ },
    \ 'separator': '︱',
    \ 'symbol': {
    \     'git_branch': '',
    \     'modified': '+',
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

" General {{{1
function! SL_bufnr() abort " {{{2
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

function! SL_path() abort " {{{2
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

function! SL_previewwindow() abort " {{{2
    return &previewwindow ? '[Prev]' : ''
endfunction

function! SL_filename() abort " {{{2
    let fn = !empty(expand('%:t'))
        \ ? expand('%:p:t')
        \ : '[No Name]'
    return fn . (&readonly ? ' ' : '')
endfunction

function! SL_modified() abort " {{{2
    return &modified ? s:sl.symbol.modified : ''
endfunction


function! SL_format_and_encoding() abort " {{{2
    let encoding = winwidth(0) < s:sl.width.min
        \ ? ''
        \ : strlen(&fileencoding)
        \ ? &fileencoding
        \ : &encoding
    let format = winwidth(0) > s:sl.width.med
        \ ? &fileformat
        \ : winwidth(0) < s:sl.width.min
        \ ? ''
        \ : &fileformat[0]
    return printf('%s[%s]', encoding, format)
endfunction

function! SL_filetype() abort " {{{2
    return strlen(&filetype) ? &filetype : ''
endfunction

function! SL_hi_group() abort " {{{2
    return '> ' . synIDattr(synID(line('.'), col('.'), 1), 'name') . ' <'
endfunction


function! SL_paste() abort " {{{2
    if &paste
        return winwidth(0) <# 55 ? '[P]' : '[PASTE]'
    else
        return ''
    endif
endfunction

function! SL_spell() abort " {{{2
    return &spell ? &spelllang : ''
endfunction

function! SL_indentation() abort " {{{2
    return winwidth(0) <# 55
        \ ? ''
        \ : &expandtab
        \ ? 's:' . &shiftwidth
        \ : 't:' . &shiftwidth
endfunction

function! SL_column_and_percent() abort " {{{2
    " The percent part was inspired by vim-line-no-indicator plugin.
    let chars = ['꜒', '꜓', '꜔', '꜕', '꜖',]
    let [c_l, l_l] = [line('.'), line('$')]
    let index = float2nr(ceil((c_l * len(chars) * 1.0) / l_l)) - 1
    let perc = chars[index]
    return winwidth(0) ># 55 ? printf('%s%2d', perc, col('.')) : ''
endfunction

function! SL_jobs() abort " {{{2
    let n_jobs = exists('g:jobs') ? len(g:jobs) : 0
    return winwidth(0) <# 55
        \ ? ''
        \ : n_jobs
        \ ? ' ' . n_jobs
        \ : ''
endfunction

function! SL_toggled() abort " {{{2
    if !exists('g:SL_toggle')
        return ''
    endif
    let sl = ''
    for [k, v] in items(g:SL_toggle)
        let str = call(v, [])
        let sl .= empty(sl)
            \ ? str . ' '
            \ : s:sl.separator . ' ' . str . ' '
    endfor
    return sl[:-2]
endfunction

function! SL_terminal() abort " {{{2
    let term_buf_nr = get(g:, 'term_buf_nr', 0)
    return term_buf_nr && index(term_list(), term_buf_nr) != -1
        \ ? '' : ''
endfunction

function! SL_qf() abort " {{{2
    return printf('[q:%d l:%d]',
        \ len(getqflist()),
        \ len(getloclist(bufnr('%')))
        \ )
endfunction

function! SL_diagnostic(mode) abort " {{{2
    let coc = SL_coc_diagnostic(a:mode)
    let ale = SL_ale(a:mode)
    let errors = coc[0] + ale[0]
    let warnings = coc[1] + ale[1]
    return s:sl_get_parsed_linting_str(errors, warnings, a:mode)
endfunction

" Plugin interfaces {{{1
function! SL_fugitive() abort " {{{2
    if winwidth(0) < s:sl.width.min | return '' | endif
    if !exists('*FugitiveHead') | return '' | endif
    let icon = s:sl.symbol.git_branch
    let head = FugitiveHead()
    return head !=# 'master' ? icon.' '.head : icon
endfunction

function! SL_signify() abort " {{{2
    if exists('*sy#repo#get_stats')
        let h = sy#repo#get_stats()
        return h !=# [-1, -1, -1] && winwidth(0) > s:sl.width.min && h !=# [0, 0, 0]
            \ ? printf('+%d ~%d -%d', h[0], h[1], h[2])
            \ : ''
    else
        return ''
    endif
endfunction

function! SL_git_hunks() abort "{{{2
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

function! SL_ale(mode) abort " {{{2
    " a:mode: 1/0 = errors/ok
    if get(g:, 'ale_enabled', 0) == 0 | return [0, 0] | endif
    let counts = ale#statusline#Count(bufnr('%'))
    let errors = counts.error + counts.style_error
    let warnings = counts.warning + counts.style_warning
    return [errors, warnings]
endfunction

function! SL_coc_diagnostic(mode) abort " {{{2
    " a:mode: 1/0 = errors/ok
    if get(g:, 'coc_enabled', 0) == 0  || !exists('b:coc_diagnostic_info')
        return [0, 0]
    endif
    let coc = b:coc_diagnostic_info
    let errors = get(coc, 'error', 0)
    let warnings = get(coc, 'warning', 0)
    return [errors, warnings]
endfunction

function! SL_coc_status() abort " {{{2
    let status = get(g:, 'coc_status', '')
    return status
endfunction

" Helpers {{{1
function! s:hi(group, bg, fg, opt) abort " {{{2
    let bg = type(a:bg) == v:t_string ? ['none', 'none' ] : a:bg
    let fg = type(a:fg) == v:t_string ? ['none', 'none'] : a:fg
    let opt = empty(a:opt) ? ['none', 'none'] : [a:opt, a:opt]
    let mode = ['gui', 'cterm']
    let cmd = 'hi ' . a:group . ' term=' . opt[1]
    for i in (range(0, len(mode)-1))
        let cmd .= printf(' %sbg=%s %sfg=%s %s=%s',
            \ mode[i], bg[i],
            \ mode[i], fg[i],
            \ mode[i], opt[i]
            \ )
    endfor
    execute cmd
endfunction

function! s:set_sl_colors() abort " {{{2
    call s:hi('User1', s:sl.colors['main'], s:sl.colors['background'], 'bold')
    call s:hi('User2', s:sl.colors['backgroundLight'], s:sl.colors['text'], 'none')
    call s:hi('User3', s:sl.colors['backgroundLight'], s:sl.colors['textDark'], 'none')
    call s:hi('User4', s:sl.colors['main'], s:sl.colors['background'], 'none')

    " Modified state
    call s:hi('User5', s:sl.colors['backgroundLight'], s:sl.colors['red'], 'bold')

    " Success & error states
    call s:hi('User6', s:sl.colors['backgroundLight'], s:sl.colors['green'], 'bold')
    call s:hi('User7', s:sl.colors['backgroundLight'], s:sl.colors['orange'], 'bold')
    " Inactive statusline
    call s:hi('User8', s:sl.colors['backgroundDark'], s:sl.colors['backgroundLight'], 'none')
endfunction

function! s:toggle_sl_item(var, funcref) abort " {{{2
    let g:SL_toggle = get(g:, 'SL_toggle', {})
    if has_key(g:SL_toggle, a:var)
        call remove(g:SL_toggle, a:var)
    else
        let g:SL_toggle[a:var] = a:funcref
    endif
endfunction

function! Get_SL(...) abort " {{{2
    let sl = ''
    " Custom functions
    if has_key(s:sl.apply, &filetype)
        let fun = get(s:sl.apply, &filetype)
        let len_f = len(fun)
        if len_f == 1
            let sl = '%{' . fun[0] . '}'
        elseif len_f == 2
            let sl = '%{' . fun[0] . '}'
            let sl .= '%=%{' . fun[-1] . '}'
        else
            for i in range(0, len_f - 2)
                if exists('*' . fun[i])
                    let sl .= (i isnot# 0 ? s:sl.separator . ' ' : '') .
                        \ '%{' . fun[i] . '}'
                endif
            endfor
            let sl .= '%=%{' . fun[-1] . '}'
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
    let sl .= '%(%{SL_fugitive()} ' . s:sl.separator . '%)'

    let sl .= '%( %{SL_spell()} ' . s:sl.separator . '%)'
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

function! s:sl_init() abort " {{{2
    set laststatus=2
    call s:set_sl_colors()
    call s:apply_sl()
    augroup SL
        autocmd!
        autocmd WinEnter,BufEnter,FocusGained * call <SID>apply_sl()
        autocmd WinLeave,FocusLost * call <SID>apply_sl(1)
        autocmd TermOpen * call <SID>apply_sl()
    augroup END
endfunction

function! s:apply_sl(...) abort " {{{2
    if &buftype ==# 'terminal'
        setlocal statusline&
        set ruler
    elseif index(s:sl.ignore, &filetype) < 0
        if !exists('a:1')
            let &statusline = Get_SL()
        else
            let &statusline = Get_SL(0)
        endif
    else
        setlocal statusline&
    endif
endfunction

function! s:sl_get_parsed_linting_str(errors, warnings, mode) abort " {{{2
    let errors_str = a:errors != 0 ?
        \ printf('%s %s', s:sl.symbol.error_sign, a:errors)
        \ : ''
    let warnings_str = a:warnings != 0 ?
        \ printf('%s %s', s:sl.symbol.warning_sign, a:warnings)
        \ : ''
    let def_str = errors_str.' '.warnings_str

    " Trim spaces
    let def_str = substitute(def_str, '^\s*\(.\{-}\)\s*$', '\1', '')
    let success_str = s:sl.symbol.success_sign

    if a:mode == 1
        return def_str
    else
        return a:errors + a:warnings == 0 ? success_str : ''
    endif
endfunction

" Commands {{{1
" SL {{{2
let s:args = [
    \   ['toggle', 'clear'],
    \   [
    \       'column_and_percent', 'format_and_encoding', 'indentation',
    \       'hi_group', 'qf'
    \   ]
    \ ]
command! -nargs=? -complete=custom,s:sl_complete_args SL
    \ call s:sl_command(<f-args>)

function! s:sl_command(...) abort " {{{2
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

function! s:sl_complete_args(a, l, p) abort " {{{2
    return join(s:args[0] + s:args[1], "\n")
endfunction

" Initialize {{{2
call <SID>sl_init()

" vim:fdl=1:
