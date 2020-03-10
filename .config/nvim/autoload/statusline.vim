" ====================================================
" Filename:    autoload/statusline.vim
" Description: Collection of functions for statusline components
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-03-10 08:24:05 CDT
" ====================================================
scriptencoding utf-8

" Linter indicators {{{2
let s:LinterChecking = g:nf ? "\uf110 " : '...'
let s:LinterWarnings = g:nf ? "\uf071 " : '•'
let s:LinterErrors = g:nf ? "\uf05e " : '•'
let s:LinterOK = ''

" Main {{{1
function! statusline#get(...) abort "{{{2
    let l:winnr = a:0 > 0 ? a:1 : winnr()
    let l:active = l:winnr == winnr()
    let l:bufnr = winbufnr(l:winnr)
    let l:default_status = '%<%f %h%m%r%'
    let l:inactive_status = ' %n %<%f %h%m%r%'
    let l:special = s:is_special_file(l:bufnr)

    if l:special != -1
        return ' '.l:special
    elseif statusline#is_not_file(l:bufnr)
        return l:default_status
    elseif ! l:active
        return l:inactive_status
    endif

    let l:sl = ''
    let l:sl .= '%( %{&buflisted?"[".'.l:bufnr.'."]":""}%)'
    let l:sl .= '%( %h%w%)'
    let l:sl .= '%( %{statusline#file_name('.l:bufnr.')}%)'
    let l:sl .= '%<'
    let l:sl .= '%( %m%r%)'
    let l:sl .= '%(  %{statusline#linter_errors('.l:bufnr.')}%)'
    let l:sl .= '%( %{statusline#linter_warnings('.l:bufnr.')}%)'

    let l:sl .= '%='
    let l:sl .= '%( %{statusline#toggled()} '.g:sl.sep.'%)'
    let l:sl .= '%( %{statusline#job_status()} '.g:sl.sep.'%)'
    let l:sl .= '%( %{statusline#lsp_status()} '.g:sl.sep.'%)'
    let l:sl .= '%( %{statusline#coc_status('.l:bufnr.')} '.g:sl.sep.'%)'
    let l:sl .= '%( %{statusline#file_type('.l:winnr.')} '.g:sl.sep.'%)'
    let l:sl .= '%( %{statusline#git_status('.l:bufnr.')} '.g:sl.sep.'%)'
    let l:sl .= '%( %l,%c%) %4(%p%% %)'
    return l:sl
endfunction

" Refresh statusline for all windows
function! statusline#refresh() abort "{{{2
    for l:win in range(1, winnr('$'))
        call setwinvar(l:win, '&statusline', '%!statusline#get('.l:win.')')
    endfor
endfunction

" Toggling {{{1
" Args {{{2
let s:args = [
    \   ['toggle', 'clear'],
    \   [
    \       'syntax_group',
    \       'git_status',
    \   ]
    \ ]

function! s:toggle_item(var, funcref) abort " {{{2
    let g:statusline_toggle = get(g:, 'statusline_toggle', [])
    let l:idx = index(g:statusline_toggle, a:funcref)
    if l:idx > -1
        call remove(g:statusline_toggle, l:idx)
    else
        call add(g:statusline_toggle, a:funcref)
    endif
endfunction

function! statusline#command(...) abort " {{{2
    let l:arg = a:0 > 0 ? a:1 : 'clear'

    if l:arg ==# 'toggle'
        let &laststatus = &laststatus != 0 ? 0 : 2
        return
    elseif l:arg ==# 'clear'
        unlet! g:statusline_toggle
        return
    endif

    for l:a in a:000
        " Check the 1st one only
        if index(s:args[1], l:a) == -1 | continue | endif
        let l:fun_ref = 'statusline#'.l:a
        call s:toggle_item(l:a, l:fun_ref)
    endfor
endfunction

function! statusline#complete_args(a, l, p) abort " {{{3
    return join(s:args[0] + s:args[1], "\n")
endfunction

" Component functions {{{1
function! s:lpad(expr) abort "{{{2
    return !empty(a:expr) ? ' '.a:expr : ''
endfunction

function! s:rpad(expr) abort "{{{2
    return !empty(a:expr) ? a:expr.' ' : ''
endfunction

" Safely call devicons
function! s:dev_icon(type) abort "{{{2
    if exists('*WebDevIconsGet'.a:type.'Symbol')
        return WebDevIconsGet{a:type}Symbol()
    endif
    return ''
endfunction

function! s:is_special_file(bufnr) abort "{{{2
    let l:f = getbufvar(a:bufnr, '&filetype')
    let l:b = getbufvar(a:bufnr, '&buftype')
    if l:f =~? '__Tagbar__'
        return '[Tagbar]'
    elseif l:f =~? '__Gundo\|NERD_tree'
        return '[NERDTree]'
        " elseif l:f =~? 'defx'
        "     return '[DEFX]'
    elseif l:f =~? 'startify'
        return '[Startify]'
    elseif l:b =~? '^\%(nofile\|acwrite\|terminal\)$'
        return empty(l:f) ? '[Scratch]' : l:f
    elseif l:f ==# 'output:///info'
        return ''
    endif
    return -1
endfunction

function! statusline#set_highlight(group, bg, fg, opt) abort " {{{2
    let g:statusline_hg = get(g:, 'statusline_hg', [])
    let l:bg = type(a:bg) == v:t_string ? ['none', 'none' ] : a:bg
    let l:fg = type(a:fg) == v:t_string ? ['none', 'none'] : a:fg
    let l:opt = empty(a:opt) ? ['none', 'none'] : [a:opt, a:opt]
    let l:mode = ['gui', 'cterm']
    let l:cmd = 'hi '.a:group.' term='.l:opt[1]
    for l:i in (range(0, len(l:mode)-1))
        let l:cmd .= printf(' %sbg=%s %sfg=%s %s=%s',
            \ l:mode[l:i], l:bg[l:i],
            \ l:mode[l:i], l:fg[l:i],
            \ l:mode[l:i], l:opt[l:i]
            \ )
    endfor
    let g:statusline_hg += [l:cmd]
    execute l:cmd
endfunction

function! statusline#get_highlight(src) abort
    let l:hl = execute('highlight '.a:src)
    let l:mregex = '\v(\w+)\=(\S+)'
    let l:idx = 0
    let l:arr = {}
    while 1
        let l:idx = match(l:hl, l:mregex, l:idx)
        if l:idx == -1
            break
        endif
        let l:m = matchlist(l:hl, l:mregex, l:idx)
        let l:idx += len(l:m[0])
        let l:arr[l:m[1]]=l:m[2]
    endwhile
    return l:arr
endfunction

function! statusline#extract(group, what, ...) abort
    if a:0 == 1
        return synIDattr(synIDtrans(hlID(a:group)), a:what, a:1)
    else
        return synIDattr(synIDtrans(hlID(a:group)), a:what)
    endif
endfunction

function! statusline#mode() abort
    " l:mode_map (0 = full size, 1 = medium abbr, 2 = short abbr)
    let l:mode_map = {
        \ 'n' :     ['NORMAL','NRM','N'],
        \ 'i' :     ['INSERT','INS','I'],
        \ 'R' :     ['REPLACE','REP','R'],
        \ 'v' :     ['VISUAL','VIS','V'],
        \ 'V' :     ['V-LINE','V-LN','V-L'],
        \ "\<C-v>": ['V-BLOCK','V-BL','V-B'],
        \ 'c' :     ['COMMAND','CMD','C'],
        \ 's' :     ['SELECT','SEL','S'],
        \ 'S' :     ['S-LINE','S-LN','S-L'],
        \ "\<C-s>": ['S-BLOCK','S-BL','S-B'],
        \ 't':      ['TERMINAL','TERM','T'],
        \ }
    let l:special_modes = {
        \ 'nerdtree':       'NERD',
        \ 'netrw':          'NETRW',
        \ 'tagbar':         'TAGS',
        \ 'undotree':       'UNDO',
        \ 'vista':          'VISTA',
        \ 'qf':             '',
        \ 'coc-explorer':   'EXPLORER',
        \ 'output:///info': 'COC-INFO',
        \ 'packager':       'PACK',
        \ }
    let l:mode = get(l:mode_map, mode(), mode())
    if winwidth(0) > g:sl.width.med
        " No abbreviation
        let l:mode_out = l:mode[0]
    elseif winwidth(0) > g:sl.width.min
        " Medium abbreviation
        let l:mode_out = l:mode[1]
    else
        " Short abbrevation
        let l:mode_out = l:mode[2]
    endif
    return get(l:special_modes, &filetype, get(l:special_modes, @%, l:mode_out))
endfunction

function! s:line_percent() abort "{{{2
    return printf('%3d%%', line('.') * 100 / line('$'))
endfunction

function! s:line_no() abort "{{{2
    let l:totlines = line('$')
    let l:maxdigits = len(string(l:totlines))
    return printf('%*d/%*d',
        \ l:maxdigits,
        \ line('.'),
        \ l:maxdigits,
        \ l:totlines
        \ )
endfunction

function! s:col_no() abort "{{{2
    return printf('%3d', virtcol('.'))
endfunction

function! statusline#bufnr(bufnr) abort
    return buflisted(a:bufnr) ? '['.a:bufnr.']' : ''
endfunction

function! statusline#job_status() abort "{{{2
    let l:status = get(g:, 'asyncrun_status')
    if empty(l:status)
        let l:status = get(g:, 'job_status')
    end
    return !empty(l:status) ? 'Job: '.l:status : ''
endfunction

function! statusline#line_info_full(bufnr) abort "{{{2
    return statusline#is_not_file(a:bufnr) ? '' :
        \ printf('%s %s %s %s :%s',
        \ s:line_percent(),
        \ statusline#line_pos(),
        \ s:line_no(),
        \ g:sl.symbol.line_no,
        \ s:col_no()
        \ )
endfunction

function! statusline#line_info() abort
    let l:line = line('.')
    let l:line_pct = l:line * 100 / line('$')
    let l:col = virtcol('.')
    return printf('%d,%d %3d%%', l:line, l:col, l:line_pct)
endfunction

function! statusline#file_type(winnr) abort "{{{2
    let l:bufnr = winbufnr(a:winnr)
    if statusline#is_not_file(l:bufnr) | return '' | endif
    let l:ftsymbol = s:rpad(s:dev_icon('FileType'))
    let l:out = ''
    if winwidth(a:winnr) > g:sl.width.med
        let l:out .= getbufvar(l:bufnr, '&filetype')
        return l:ftsymbol.l:out
    endif
    return ''
endfunction

function! statusline#file_format(winnr) abort "{{{2
    let l:bufnr = winbufnr(a:winnr)
    let l:ff = getbufvar(l:bufnr, '&fileformat')
    if l:ff ==# 'unix' || statusline#is_not_file(l:bufnr) 
        return ''
    endif
    let l:ffsymbol = s:dev_icon('FileFormat')
    " No output if fileformat is unix (standard)
    return winwidth(a:winnr) > g:sl.width.med
        \ ? (l:ff.s:lpad(l:ffsymbol))
        \ : ''
endfunction

function! statusline#is_not_file(...) abort "{{{2
    " Return true if not treated as file
    let l:bufnr = a:0 > 0 ? a:1 : bufnr('%')
    let l:bufname = bufname(l:bufnr)
    let l:ft = getbufvar(l:bufnr, '&filetype')
    let l:exclude = [
        \ 'help',
        \ 'startify',
        \ 'nerdtree',
        \ 'netrw',
        \ 'output',
        \ 'vista',
        \ 'undotree',
        \ 'vimfiler',
        \ 'tagbar',
        \ 'minpac',
        \ 'packager',
        \ 'vista',
        \ 'qf',
        \ 'defx',
        \ 'coc-explorer',
        \ 'output:///info',
        \ 'nofile',
        \ ]
    if index(l:exclude, l:ft) > -1
        \ || index(l:exclude, fnamemodify(l:bufname, ':t')) > -1
        \ || index(l:exclude, l:bufname) > -1
        return 1
    endif
    return 0
endfunction

function! statusline#modified(...) abort "{{{2
    let l:bufnr = a:0 > 0 ? a:1 : bufnr('%')
    let l:mod = getbufvar(l:bufnr, '&modified')
    return l:mod ? g:sl.symbol.modified : &modifiable ? '' : g:sl.symbol.unmodifiable
endfunction

function! statusline#read_only(...) abort "{{{2
    let l:bufnr = a:0 > 0 ? a:1 : bufnr('%')
    let l:ro = getbufvar(l:bufnr, '&readonly')
    return !statusline#is_not_file(l:bufnr) && l:ro ? g:sl.symbol.readonly : ''
endfunction

function! statusline#syntax_group() abort " {{{2
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
endfunction


function! statusline#file_name(...) abort "{{{2
    let l:bufnr = a:0 > 0 ? a:1 : bufnr('%')
    let l:special = s:is_special_file(l:bufnr)
    if l:special != -1 | return l:special | endif
    if statusline#is_not_file(l:bufnr) | return '' | endif

    let l:fname = fnamemodify(bufname(l:bufnr), ':~:.')
    if winwidth(0) < g:sl.width.min
        let l:fname = pathshorten(l:fname)
    endif
    return l:fname
endfunction

function! statusline#file_size(...) abort "{{{2
    let l:bufnr = a:0 > 0 ? a:1 : bufnr('%')
    let l:div = 1024.0
    let l:num = getfsize(bufname(l:bufnr))
    if l:num <= 0 | return '' | endif
    " Return bytes plain without decimal or unit
    if l:num < l:div | return l:num | endif
    let l:num /= l:div
    for l:unit in ['k', 'M', 'G', 'T', 'P', 'E', 'Z']
        if l:num < l:div
            return printf('%.1f%s', l:num, l:unit)
        endif
        let l:num /= l:div
    endfor
    " This is quite a large file!
    return printf('%.1fY')
endfunction

function! statusline#file_encoding(...) abort "{{{2
    " Only return a value if != utf-8
    let l:bufnr = a:0 > 0 ? a:1 : bufnr('%')
    let l:enc = getbufvar(l:bufnr, '&fileencoding')
    return l:enc !=? 'utf-8' ? l:enc : ''
endfunction

function! statusline#tab_name(bufnr) abort "{{{3
    let l:fname = bufname(a:bufnr)
    return l:fname =~? '__Tagbar__' ? 'Tagbar' :
        \ l:fname =~? 'NERD_tree' ? 'NERDTree' :
        \ statusline#file_name(a:bufnr)
endfunction

function! statusline#git_summary(...) abort "{{{2
    " Look for status in this order
    " 1. coc-git
    " 2. gitgutter
    " 3. signify
    let l:bufnr = a:0 > 0 ? a:1 : bufnr('%')
    let l:bufvars = getbufvar(l:bufnr, '')
    if has_key(l:bufvars, 'coc_git_status')
        let l:coc_git_status = getbufvar(l:bufnr, 'coc_git_status')
        return trim(l:coc_git_status)
    endif
    if exists('*gitgutter#hunk#summary')
        let l:githunks = gitgutter#hunk#summary(l:bufnr)
    elseif exists('*sy#repo#get_stats')
        let l:githunks = sy#repo#get_stats()
    else
        return ''
    endif
    let l:added =     l:githunks[0] ? printf('+%d ', l:githunks[0])   : ''
    let l:changed =   l:githunks[1] ? printf('~%d ', l:githunks[1])   : ''
    let l:deleted =   l:githunks[2] ? printf('-%d ', l:githunks[2])   : ''
    return printf('%s%s%s',
        \ l:added,
        \ l:changed,
        \ l:deleted,
        \ )
endfunction

function! statusline#git_branch() abort "{{{2
    if exists('g:coc_git_status')
        return join(split(g:coc_git_status)[1:-1]).' '
    elseif exists('*FugitiveHead')
        return FugitiveHead()
    endif
    return ''
endfunction

function! statusline#git_status(...) abort "{{{2
    let l:bufnr = a:0 > 0 ? a:1 : bufnr('%')
    if !statusline#is_not_file(l:bufnr) && winwidth(0) > g:sl.width.min
        let l:branch = statusline#git_branch()
        let l:hunks = statusline#git_summary(l:bufnr)
        return l:branch !=# '' ? printf('%s%s%s',
            \ l:hunks,
            \ ' '.substitute(l:branch, 'master', '', ''),
            \ g:sl.symbol.branch
            \ ) : ''
    endif
    return ''
endfunction

function! statusline#venv_name(bufnr) abort "{{{2
    if exists('g:did_coc_loaded') | return '' | endif
    return getbufvar(a:bufnr, '&filetype') ==# 'python' && !empty($VIRTUAL_ENV)
        \ ? printf(' (%s)', split($VIRTUAL_ENV, '/')[-1])
        \ : ''
endfunction

function! statusline#current_tag() abort "{{{2
    if winwidth(0) < g:sl.width.max | return '' | endif
    let l:coc_func = get(b:, 'coc_current_function', '')
    if l:coc_func !=# '' | return l:coc_func | endif
    if exists('*tagbar#currenttag')
        return tagbar#currenttag('%s', '', 'f')
    endif
    return ''
endfunction

function! statusline#coc_status(bufnr) abort "{{{2
    if statusline#is_not_file(a:bufnr) | return '' | endif
    if winwidth(0) > g:sl.width.min && get(g:, 'did_coc_loaded', 0)
        let l:coc = get(g:, 'coc_status')
        if !empty(l:coc) | return l:coc | endif
    endif
    return ''
endfunction

function! statusline#lsp_status() abort
    return v:lua.vim.lsp.buf.server_ready() ? 'LSP' : ''
endfunction

function! s:ale_linted(bufnr) abort
    return get(g:, 'ale_enabled', 0) == 1
        \ && getbufvar(a:bufnr, 'ale_linted', 0) > 0
        \ && ale#engine#IsCheckingBuffer(a:bufnr) == 0
endfunction

function! s:coc_error_ct(bufnr) abort "{{{2
    let l:bufvars = getbufvar(a:bufnr, '')
    let l:coc = get(l:bufvars, 'coc_diagnostic_info', {})
    let l:ct = get(l:coc, 'error', 0)
    return l:ct
endfunction

function! s:ale_error_ct(bufnr) abort "{{{2
    if !s:ale_linted(a:bufnr) | return 0 | endif
    let l:counts = ale#statusline#Count(a:bufnr)
    return l:counts.error + l:counts.style_error
endfunction

function! s:lsp_error_ct()
    return v:lua.vim.lsp.util.buf_diagnostics_count('Error')
endfunction

function! s:ale_warning_ct(bufnr) abort "{{{2
    if !s:ale_linted(a:bufnr) | return 0 | endif
    let l:counts = ale#statusline#Count(a:bufnr)
    return l:counts.warning + l:counts.style_warning
endfunction

function! s:lsp_warning_ct()
    return v:lua.vim.lsp.util.buf_diagnostics_count('Warning')
endfunction

function! s:coc_warning_ct(bufnr) abort " {{{2
    let l:bufvars = getbufvar(a:bufnr, '')
    let l:coc = get(l:bufvars, 'coc_diagnostic_info', {})
    let l:ct = get(l:coc, 'warning', 0)
    return l:ct
endfunction

function! statusline#linter_errors(bufnr) abort " {{{2
    let l:ct = s:coc_error_ct(a:bufnr) + s:ale_error_ct(a:bufnr) + s:lsp_error_ct()
    return l:ct > 0 ? g:sl.symbol.error_sign.l:ct : ''
endfunction

function! statusline#linter_warnings(bufnr) abort " {{{2
    let l:ct = s:coc_warning_ct(a:bufnr) + s:ale_warning_ct(a:bufnr) + s:lsp_warning_ct()
    return l:ct > 0 ? g:sl.symbol.warning_sign.l:ct : ''
endfunction

function! statusline#toggled() abort " {{{2
    if !exists('g:statusline_toggle') | return '' | endif
    let l:sl = ''
    for l:v in g:statusline_toggle
        let l:str = call(l:v, [])
        let l:sl .= empty(l:sl) ? l:str.' ' : g:sl.sep.' '.l:str.' '
    endfor
    return l:sl[:-2]
endfunction

" vim:fdm=marker fdl=1:
