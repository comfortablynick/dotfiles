scriptencoding utf-8

" Globals {{{1
" Nvim {{{2
let s:loaded_treesitter = 0
if has('nvim')
    let s:webdevicons = v:lua.require('nvim-web-devicons')
endif

" Linter indicators {{{2
let s:LinterChecking = g:nf ? "\uf110 " : '...'
let s:LinterWarnings = g:nf ? "\uf071 " : '•'
let s:LinterErrors = g:nf ? "\uf05e " : '•'
let s:LinterOK = ''

" Main {{{1
function statusline#get() "{{{2
    let l:sl = ''
    let l:sl ..= '%(%1*%{statusline#bufnr()}%* %)'
    let l:sl ..= '%(%{statusline#bufnr_inactive()} %)'
    let l:sl ..= '%(%{statusline#file_name()} %)'
    let l:sl ..= '%<'
    let l:sl ..= '%(%h%w%q%m%r %)'
    let l:sl ..= '%(  %4*%{statusline#linter_errors()}%*%)'
    let l:sl ..= '%( %5*%{statusline#linter_warnings()}%*%)'
    let l:sl ..= '%( %6*%{statusline#linter_hints()}%*%)'

    let l:sl ..= '%='
    let l:sl ..= '%( %{statusline#toggled()} '..g:sl.sep..'%)'
    let l:sl ..= '%( %{statusline#mucomplete_method()} %)'
    let l:sl ..= '%( %{statusline#job_status()} '..g:sl.sep..'%)'
    let l:sl ..= '%( %{statusline#current_tag()}%)'
    let l:sl ..= '%( %-20.50{statusline#lsp_status()}%)'
    let l:sl ..= '%( %{statusline#coc_status()} %)'
    let l:sl ..= '%( %{statusline#file_type()} %)'
    let l:sl ..= '%(%3* %{statusline#git_status()} %*%)'
    let l:sl ..= '%(%2* %{statusline#line_info()}%*%)'
    return l:sl
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

function s:toggle_item(var, funcref) " {{{2
    let g:statusline_toggle = get(g:, 'statusline_toggle', [])
    let l:idx = index(g:statusline_toggle, a:funcref)
    if l:idx > -1
        call remove(g:statusline_toggle, l:idx)
    else
        call add(g:statusline_toggle, a:funcref)
    endif
endfunction

function statusline#command(...) " {{{2
    let l:arg = a:0 > 0 ? a:1 : 'toggle'

    if l:arg ==# 'toggle'
        let &laststatus = &laststatus != 0 ? 0 : 2
        return
    elseif l:arg ==# 'clear'
        unlet! g:statusline_toggle
        return
    endif

    for l:a in a:000
        " Check the 1st one only
        if index(s:args[1], l:a) > -1
            let l:fun_ref = 'statusline#'.l:a
            call s:toggle_item(l:a, l:fun_ref)
        endif
    endfor
endfunction

function statusline#complete_args(a, l, p) " {{{3
    return join(s:args[0] + s:args[1], "\n")
endfunction

" Component functions {{{1
function s:is_active() "{{{2
    return win_getid() ==# g:actual_curwin
endfunction

function s:is_active_file() "{{{2
    return s:is_active() && !statusline#is_not_file()
endfunction

function s:lpad(expr) "{{{2
    return !empty(a:expr) ? ' '.a:expr : ''
endfunction

function s:rpad(expr) "{{{2
    return !empty(a:expr) ? a:expr.' ' : ''
endfunction

" Safely call devicons
function s:dev_icon(type) "{{{2
    if exists('*WebDevIconsGet'.a:type.'Symbol')
        return WebDevIconsGet{a:type}Symbol()
    endif
    if a:type ==# 'FileType' && exists('s:webdevicons')
        return s:webdevicons.get_icon(expand('%'), &filetype)
    endif
    return ''
endfunction

function statusline#set_highlight(group, bg, fg, opt) " {{{2
    let g:statusline_hg = get(g:, 'statusline_hg', [])
    let l:bg = type(a:bg) == v:t_string ? ['none', 'none' ] : a:bg
    let l:fg = type(a:fg) == v:t_string ? ['none', 'none'] : a:fg
    let l:opt = empty(a:opt) ? ['none', 'none'] : [a:opt, a:opt]
    let l:mode = ['gui', 'cterm']
    let l:cmd = 'hi '.a:group.' term='.l:opt[1]
    for l:i in (range(0, len(l:mode)-1))
        let l:cmd ..= printf(' %sbg=%s %sfg=%s %s=%s',
            \ l:mode[l:i], l:bg[l:i],
            \ l:mode[l:i], l:fg[l:i],
            \ l:mode[l:i], l:opt[l:i]
            \ )
    endfor
    let g:statusline_hg += [l:cmd]
    execute l:cmd
endfunction

function statusline#get_highlight(src)
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

function statusline#extract(group, what, ...)
    if a:0 == 1
        return synIDattr(synIDtrans(hlID(a:group)), a:what, a:1)
    else
        return synIDattr(synIDtrans(hlID(a:group)), a:what)
    endif
endfunction

function statusline#mode()
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

function s:line_percent() "{{{2
    return printf('%3d%%', line('.') * 100 / line('$'))
endfunction

function s:line_no() "{{{2
    let l:totlines = line('$')
    let l:maxdigits = len(string(l:totlines))
    return printf('%*d/%*d',
        \ l:maxdigits,
        \ line('.'),
        \ l:maxdigits,
        \ l:totlines
        \ )
endfunction

function s:col_no() "{{{2
    return printf('%3d', virtcol('.'))
endfunction

function statusline#unicode_number(num) "{{{2
    if a:num > 0 && a:num <= 20
        return nr2char(char2nr('① ') + (a:num - 1))
    else
        return a:num
    endif
endfunction

function statusline#line_info_full() "{{{2
    return !s:is_active_file() ? '' :
        \ printf('%s %s %s %s :%s',
        \ s:line_percent(),
        \ g:sl.symbol.lines,
        \ s:line_no(),
        \ g:sl.symbol.line_no,
        \ s:col_no()
        \ )
endfunction

function statusline#line_info() "{{{2
    if ! s:is_active_file() | return '' | endif
    let l:line = line('.')
    let l:line_pct = l:line * 100 / line('$')
    let l:col = virtcol('.')
    return printf('%d,%d %3d%%', l:line, l:col, l:line_pct)
endfunction

function statusline#bufnr() "{{{2
    if ! s:is_active() | return '' | endif
    let l:bufnr = bufnr('')
    return buflisted(l:bufnr) ? '  '.l:bufnr.' ' : ''
endfunction

function statusline#bufnr_inactive() "{{{2
    if s:is_active() | return '' | endif
    let l:bufnr = bufnr('')
    return buflisted(l:bufnr) ? '['.l:bufnr.']' : ''
endfunction

function statusline#job_status() "{{{2
    if !s:is_active_file() | return '' | endif
    let l:status = get(g:, 'asyncrun_status')
    if empty(l:status)
        let l:status = get(g:, 'job_status')
    end
    return !empty(l:status) ? 'Job: '.l:status : ''
endfunction

function statusline#file_type() "{{{2
    if !s:is_active_file() | return '' | endif
    let l:ftsymbol = s:rpad(s:dev_icon('FileType'))
    let l:out = ''
    if winwidth(0) > g:sl.width.med
        let l:out ..= &filetype
        return l:ftsymbol.l:out
    endif
    return ''
endfunction

function statusline#file_format() "{{{2
    if !s:is_active_file() | return '' | endif
    let l:ff = &fileformat
    if l:ff ==# 'unix' || statusline#is_not_file()
        return ''
    endif
    let l:ffsymbol = s:dev_icon('FileFormat')
    " No output if fileformat is unix (standard)
    return winwidth(0) > g:sl.width.med
        \ ? l:ff.s:lpad(l:ffsymbol)
        \ : ''
endfunction

function statusline#is_not_file() "{{{2
    " Return true if not treated as file
    let l:bufname = @%
    let l:ft = &filetype
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

function statusline#modified() "{{{2
    return &modified ? g:sl.symbol.modified : &modifiable ? '' : g:sl.symbol.unmodifiable
endfunction

function statusline#read_only() "{{{2
    return !statusline#is_not_file() && &readonly ? g:sl.symbol.readonly : ''
endfunction

function statusline#syntax_group() " {{{2
    return synIDattr(synID(line('.'), col('.'), 1), 'name')
endfunction

function statusline#file_name() "{{{2
    let l:ft = &filetype
    let l:bt = &buftype
    if l:ft ==# 'help'
        return expand('%:t')
    elseif l:ft =~? 'startify'
        return '[Startify]'
    elseif l:ft ==# 'output:///info'
        return ''
    elseif l:bt =~? '^\%(nofile\|acwrite\)$' && empty(l:ft)
        return '[Scratch]'
    endif
    let l:fname = expand('%:~:.')
    if winwidth(0) < g:sl.width.min
        let l:fname = pathshorten(l:fname)
    endif
    return l:fname
endfunction

function statusline#file_size() "{{{2
    let l:div = 1024.0
    let l:num = getfsize(@%)
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

function statusline#file_encoding() "{{{2
    " Only return a value if != utf-8
    return &fileencoding !=? 'utf-8' ? &fileencoding : ''
endfunction

function statusline#tab_name() "{{{3
    let l:fname = @%
    return l:fname =~? '__Tagbar__' ? 'Tagbar' :
        \ l:fname =~? 'NERD_tree' ? 'NERDTree' :
        \ statusline#file_name()
endfunction

function statusline#git_summary() "{{{2
    " Look for status in this order
    " 1. coc-git
    " 2. gitgutter
    " 3. signify
    if exists('b:gitsigns_status')
        return trim(b:gitsigns_status)
    elseif exists('b:coc_git_status')
        return trim(b:coc_git_status)
    elseif exists('*GitGutterGetHunkSummary')
        let l:githunks = GitGutterGetHunkSummary()
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

function statusline#git_branch() "{{{2
    if exists('g:coc_git_status')
        " TODO: needed on vim8; check to see if still needed
        return substitute(g:coc_git_status, '', '', '')
    elseif exists('*FugitiveHead')
        return FugitiveHead()
    endif
    return ''
endfunction

function statusline#git_status() "{{{2
    if !s:is_active_file()
        \ || !filereadable(@%)
        \ || winwidth(0) < g:sl.width.min
        return ''
    endif
    let l:branch = statusline#git_branch()
    if empty(l:branch) | return '' | endif
    let l:hunks = s:rpad(statusline#git_summary())
    " Assume master branch
    return printf('%s%s%s',
        \ l:hunks,
        \ substitute(l:branch, 'master', '', ''),
        \ g:sl.symbol.branch,
        \ )
endfunction

function statusline#venv_name() "{{{2
    if exists('g:did_coc_loaded') | return '' | endif
    return &filetype ==# 'python' && !empty($VIRTUAL_ENV)
        \ ? printf(' (%s)', split($VIRTUAL_ENV, '/')[-1])
        \ : ''
endfunction

function statusline#current_tag() "{{{2
    if winwidth(0) < g:sl.width.max | return '' | endif
    let l:tag = get(b:, 'coc_current_function', '')
    if l:tag !=# '' | return l:tag | endif
    " if exists('*nvim_treesitter#statusline')
    "     let l:tag = nvim_treesitter#statusline({'indicator_size': 50})
    "     if l:tag !=# v:null | return l:tag | endif
    " elseif !exists('*nvim_treesitter#statusline') && s:loaded_treesitter ==# 0
    "     runtime autoload/nvim_treesitter.vim
    "     let s:loaded_treesitter = 1
    " endif
    if exists('*tagbar#currenttag')
        return tagbar#currenttag('%s', '', 'f')
    endif
    return ''
endfunction

function statusline#coc_status() "{{{2
    if !s:is_active_file() | return '' | endif
    if winwidth(0) > g:sl.width.min && exists('*coc#status')
        return coc#status()
    endif
    return ''
endfunction

function statusline#lsp_status() "{{{2
    if !s:is_active_file() || !has('nvim') | return '' | endif
    " return '[LSP]'
    return luaeval('require"config.lsp".attached_lsps()')
endfunction

function s:ale_linted() "{{{2
    return get(g:, 'ale_enabled', 0) == 1
        \ && get(b:, 'ale_linted', 0) > 0
        \ && ale#engine#IsCheckingBuffer(0) == 0
endfunction

function s:coc_error_ct() "{{{2
    let l:coc = get(b:, 'coc_diagnostic_info', {})
    let l:ct = get(l:coc, 'error', 0)
    return l:ct
endfunction

function s:ale_error_ct() "{{{2
    if !s:ale_linted() | return 0 | endif
    let l:counts = ale#statusline#Count(bufnr('%'))
    return l:counts.error + l:counts.style_error
endfunction

function s:lsp_error_ct() "{{{2
    if has('nvim')
        return v:lua.vim.lsp.diagnostic.get_count(0, 'Error')
    endif
    return 0
endfunction

function s:lsp_hint_ct() "{{{2
    if has('nvim')
        return v:lua.vim.lsp.diagnostic.get_count(0, 'Hint')
    endif
    return 0
endfunction

function s:ale_warning_ct() "{{{2
    if !s:ale_linted() | return 0 | endif
    let l:counts = ale#statusline#Count(bufnr('%'))
    return l:counts.warning + l:counts.style_warning
endfunction

function s:lsp_warning_ct() "{{{2
    if has('nvim')
        return v:lua.vim.lsp.diagnostic.get_count(0, 'Warning')
    endif
    return 0
endfunction

function s:coc_warning_ct() " {{{2
    let l:coc = get(b:, 'coc_diagnostic_info', {})
    let l:ct = get(l:coc, 'warning', 0)
    return l:ct
endfunction

function statusline#linter_errors() " {{{2
    if !s:is_active_file() | return '' | endif
    let l:ct = s:coc_error_ct() + s:ale_error_ct() + s:lsp_error_ct()
    return l:ct > 0 ? g:sl.symbol.error_sign..l:ct : ''
endfunction

function statusline#linter_warnings() " {{{2
    if !s:is_active_file() | return '' | endif
    let l:ct = s:coc_warning_ct() + s:ale_warning_ct() + s:lsp_warning_ct()
    return l:ct > 0 ? g:sl.symbol.warning_sign..l:ct : ''
endfunction

function statusline#linter_hints() " {{{2
    if !s:is_active_file() | return '' | endif
    let l:ct = s:lsp_hint_ct()
    return l:ct > 0 ? g:sl.symbol.hint_sign..l:ct : ''
endfunction

function statusline#mucomplete_method() "{{{2
    if !exists('g:mucomplete_current_method')
        \ || !s:is_active_file()
        \ || winwidth(0) < g:sl.width.med
        return ''
    endif
    return '['.g:mucomplete_current_method.']'
endfunction

function statusline#toggled() " {{{2
    if !exists('g:statusline_toggle') | return '' | endif
    let l:sl = ''
    for l:v in g:statusline_toggle
        let l:str = {l:v}()
        let l:sl ..= empty(l:sl) ? l:str.' ' : g:sl.sep.' '.l:str.' '
    endfor
    return l:sl[:-2]
endfunction

" vim:fdm=marker fdl=1:
