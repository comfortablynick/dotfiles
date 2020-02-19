" ====================================================
" Filename:    autoload/statusline.vim
" Description: Statusline components
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-19 08:07:02 CST
" ====================================================
scriptencoding utf-8

" Variables {{{1
" Window widths {{{2
let g:sl.width.min = 90                                          " Width for using some expanded sections
let g:sl.width.med = 140                                         " Secondary width for some sections
let g:sl.width.max = 200                                         " Largest width for some (unnecessary) sections

" Symbols/glyphs {{{2
" let s:pl = get(g:, 'LL_pl', 0)
let s:nf = !$MOSH_CONNECTION
let s:LineNoSymbol = ''                                     " Use  for line; alt: '␤'
let s:GitSymbol = s:nf ? ' ' : ''                        " Use git symbol unless no nerd fonts
let s:BranchSymbol = ''                                    " Git branch symbol
let s:LineSymbol = '☰ '                                      " Is 'Ξ' ever needed?
let s:ROSymbol = ' '                                        " Read-only symbol
let s:ModSymbol = ' [+]'                                     " File modified symbol
let s:SimpleSep = $SUB ==# '|' ? 1 : 0                       " Use simple section separators instead of PL (no other effects)
let s:FnSymbol = 'ƒ '                                        " Use for current function

" Linter indicators {{{2
let s:LinterChecking = s:nf ? "\uf110 " : '...'
let s:LinterWarnings = s:nf ? "\uf071 " : '•'
let s:LinterErrors = s:nf ? "\uf05e " : '•'
let s:LinterOK = ''

" Functions {{{1
function! statusline#set_highlight(group, bg, fg, opt) abort " {{{2
    let g:statusline_hg = get(g:, 'statusline_hg', [])
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
    let g:statusline_hg += [cmd]
    execute cmd
endfunction

function! statusline#get_highlight(src) abort
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

function! statusline#extract(group, what, ...) abort
    if a:0 == 1
        return synIDattr(synIDtrans(hlID(a:group)), a:what, a:1)
    else
        return synIDattr(synIDtrans(hlID(a:group)), a:what)
    endif
endfunction

function! statusline#bufnr() abort
    return '['.bufnr('%').']'
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
    let totlines = line('$')
    let maxdigits = len(string(totlines))
    return printf('%*d/%*d',
        \ maxdigits,
        \ line('.'),
        \ maxdigits,
        \ totlines
        \ )
endfunction

function! s:col_no() abort "{{{2
    return printf('%3d', virtcol('.'))
endfunction

function! statusline#job_status() abort "{{{2
    let l:status = get(g:, 'asyncrun_status', '')
    return !empty(l:status) ? 'Job: '.l:status : ''
endfunction

function! statusline#line_info_full() abort "{{{2
    return statusline#is_not_file() ? '' :
        \ printf('%s %s %s %s :%s',
        \ s:line_percent(),
        \ statusline#line_pos(),
        \ s:line_no(),
        \ s:LineNoSymbol,
        \ s:col_no()
        \ )
endfunction

function! statusline#line_info() abort
    let l:line = line('.')
    let l:line_pct = l:line * 100 / line('$')
    let l:col = virtcol('.')
    return printf('%d,%d %3d%%', l:line, l:col, l:line_pct)
endfunction

function! statusline#file_type() abort "{{{2
    if statusline#is_not_file() | return '' | endif
    let l:ftsymbol = s:nf &&
        \ exists('*WebDevIconsGetFileTypeSymbol') ?
        \ ' '.WebDevIconsGetFileTypeSymbol() :
        \ ''
    " Don't need venv if we have coc_status
    let l:venv = exists('g:coc_status') ? '' : statusline#venv_name()
    let l:out = ''
    if winwidth(0) > g:sl.width.med
        if empty(expand('%:e'))
            let l:out .= &filetype
        endif
        return l:out.l:ftsymbol.l:venv
    endif
    return ''
endfunction

function! statusline#file_format() abort "{{{2
    let ffsymbol = s:nf &&
        \ exists('*WebDevIconsGetFileFormatSymbol') ?
        \ WebDevIconsGetFileFormatSymbol() :
        \ ''
    " No output if fileformat is unix (standard)
    return &fileformat !=? 'unix' ?
        \ statusline#is_not_file() ?
        \ '' : winwidth(0) > g:sl.width.med
        \ ? (&fileformat . ' ' . ffsymbol )
        \ : ''
        \ : ''
endfunction

function! statusline#is_not_file() abort "{{{2
    " Return true if not treated as file
    let exclude = [
        \ 'help',
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
        \ 'coc-explorer',
        \ 'output:///info',
        \ 'nofile',
        \ ]
    if index(exclude, &filetype) > -1
        \ || index(exclude, expand('%:t')) > -1
        \ || index(exclude, expand('%')) > -1
        return 1
    endif
    return 0
endfunction

function! statusline#modified() abort "{{{2
    return &modified ? g:sl.symbol.modified : &modifiable ? '' : g:sl.symbol.unmodifiable
endfunction

function! statusline#read_only() abort "{{{2
    return !statusline#is_not_file() && &readonly ? g:sl.symbol.readonly : ''
endfunction

function! statusline#syntax_group() abort " {{{2
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
endfunction

function! s:is_special_file() abort "{{{2
    let f = @%
    let b = &buftype
    if empty(f)
        return '[No Name]'
    elseif f =~? '__Tagbar__'
        return ''
    elseif f =~? '__Gundo\|NERD_tree'
        return ''
    elseif b ==? 'quickfix'
        return '[Quickfix List]'
    elseif b =~? '^\%(nofile\|acwrite\|terminal\)$'
        return empty(f) ? '[Scratch]' : f
    elseif b ==? 'help'
        return fnamemodify(f, ':t')
    elseif f ==# 'output:///info'
        return ''
    endif
    return -1
endfunction

function! statusline#file_name() abort "{{{2
    let special = s:is_special_file()
    if special != -1 | return special | endif
    if statusline#is_not_file() | return '' | endif

    let fname = fnamemodify(expand('%'), ':~:.')
    if winwidth(0) < g:sl.width.min
        let fname = pathshorten(fname)
    endif
    return fname
endfunction

function! statusline#file_size() abort "{{{2
    let div = 1024.0
    let num = getfsize(expand('%:p'))
    if num <= 0 | return '' | endif
    " Return bytes plain without decimal or unit
    if num < div | return num | endif
    let num /= div
    for unit in ['k', 'M', 'G', 'T', 'P', 'E', 'Z']
        if num < div
            return printf('%.1f%s', num, unit)
        endif
        let num /= div
    endfor
    " This is quite a large file!
    return printf('%.1fY')
endfunction

function! statusline#file_encoding() abort "{{{2
    " Only return a value if != utf-8
    return &fileencoding !=? 'utf-8' ? &fileencoding : ''
endfunction

function! statusline#tab_name() abort "{{{3
    let fname = @%
    return fname =~? '__Tagbar__' ? 'Tagbar' :
        \ fname =~? 'NERD_tree' ? 'NERDTree' :
        \ statusline#file_name()
endfunction

function! statusline#git_summary() abort "{{{2
    " Look for status in this order
    " 1. coc-git
    " 2. gitgutter
    " 3. signify
    if exists('b:coc_git_status') | return trim(b:coc_git_status) | endif
    if exists('*GitGutterGetHunkSummary')
        let githunks = GitGutterGetHunkSummary()
    elseif exists('*sy#repo#get_stats')
        let githunks = sy#repo#get_stats()
    else
        return ''
    endif
    let added =     githunks[0] ? printf('+%d ', githunks[0])   : ''
    let changed =   githunks[1] ? printf('~%d ', githunks[1])   : ''
    let deleted =   githunks[2] ? printf('-%d ', githunks[2])   : ''
    return printf('%s%s%s',
        \ added,
        \ changed,
        \ deleted,
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

function! statusline#git_status() abort "{{{2
    if !statusline#is_not_file() && winwidth(0) > g:sl.width.min
        let branch = statusline#git_branch()
        let hunks = statusline#git_summary()
        return branch !=# '' ? printf('%s%s%s',
            \ hunks,
            \ ' '.substitute(branch, 'master', '', ''),
            \ g:sl.symbol.branch
            \ ) : ''
    endif
    return ''
endfunction

function! statusline#venv_name() abort "{{{2
    if exists('g:did_coc_loaded') | return '' | endif
    return &filetype ==# 'python' && !empty($VIRTUAL_ENV)
        \ ? printf(' (%s)', split($VIRTUAL_ENV, '/')[-1])
        \ : ''
endfunction

function! statusline#current_tag() abort "{{{2
    if winwidth(0) < g:sl.width.max | return '' | endif
    let coc_func = get(b:, 'coc_current_function', '')
    if coc_func !=# '' | return coc_func | endif
    if exists('*tagbar#currenttag')
        return tagbar#currenttag('%s', '', 'f')
    endif
    return ''
endfunction

function! statusline#coc_status() abort "{{{2
    if statusline#is_not_file() | return '' | endif
    if winwidth(0) > g:sl.width.min && get(g:, 'did_coc_loaded', 0)
        let l:coc = get(g:, 'coc_status')
        if !empty(l:coc) | return l:coc | endif
    endif
    return ''
endfunction

function! s:ale_linted() abort
    return get(g:, 'ale_enabled', 0) == 1
        \ && getbufvar(bufnr(''), 'ale_linted', 0) > 0
        \ && ale#engine#IsCheckingBuffer(bufnr('')) == 0
endfunction

function! s:coc_error_ct() abort "{{{2
    let l:coc = get(b:, 'coc_diagnostic_info', {})
    let l:ct = get(l:coc, 'error', 0)
    return l:ct
endfunction

function! s:ale_error_ct() abort "{{{2
    if !s:ale_linted() | return 0 | endif
    let l:counts = ale#statusline#Count(bufnr(''))
    return l:counts.error + l:counts.style_error
endfunction

function! s:ale_warning_ct() abort "{{{2
    if !s:ale_linted() | return 0 | endif
    let l:counts = ale#statusline#Count(bufnr(''))
    return l:counts.warning + l:counts.style_warning
endfunction

function! s:coc_warning_ct() abort " {{{2
    let l:coc = get(b:, 'coc_diagnostic_info', {})
    let l:ct = get(l:coc, 'warning', 0)
    return l:ct
endfunction

function! statusline#linter_errors() abort " {{{2
    let l:ct = s:coc_error_ct() + s:ale_error_ct()
    return l:ct > 0 ? g:sl.symbol.error_sign.l:ct : ''
endfunction

function! statusline#linter_warnings() abort " {{{2
    let l:ct = s:coc_warning_ct() + s:ale_warning_ct()
    return l:ct > 0 ? g:sl.symbol.warning_sign.l:ct : ''
endfunction

function! statusline#toggled() abort " {{{2
    if !exists('g:statusline_toggle')
        return ''
    endif
    let sl = ''
    for [k, v] in items(g:statusline_toggle)
        let str = call(v, [])
        let sl .= empty(sl)
            \ ? str . ' '
            \ : g:sl.separator.' '.str.' '
    endfor
    return sl[:-2]
endfunction

" Toggle {{{1
" Args {{{2
let s:args = [
    \   ['toggle', 'clear'],
    \   [
    \       'syntax_group',
    \   ]
    \ ]

function! s:toggle_sl_item(var, funcref) abort " {{{2
    let g:statusline_toggle = get(g:, 'statusline_toggle', {})
    if has_key(g:statusline_toggle, a:var)
        call remove(g:statusline_toggle, a:var)
    else
        let g:statusline_toggle[a:var] = a:funcref
    endif
endfunction

function! statusline#sl_command(...) abort " {{{2
    let arg = exists('a:1') ? a:1 : 'clear'

    if arg ==# 'toggle'
        let &laststatus = (&laststatus != 0 ? 0 : 2)
        let &showmode = (&laststatus == 0 ? 1 : 0)
        return
    elseif arg ==# 'clear'
        unlet! g:statusline_toggle
        return
    endif

    " Split args in case we have many
    let args = split(arg, ' ')

    " Check the 1st one only
    if index(s:args[1], args[0], 0) == -1
        return
    endif

    for a in args
        let fun_ref = 'statusline#'.arg
        call s:toggle_sl_item(arg, fun_ref)
    endfor
endfunction

function! statusline#sl_complete_args(a, l, p) abort " {{{3
    return join(s:args[0] + s:args[1], "\n")
endfunction

" vim:fdm=expr:
