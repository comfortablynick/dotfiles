" vim: fdl=1
" ====================================================
" Filename:    plugin/lightline.vim
" Description: Config for lightline.vim
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-01
" ====================================================
scriptencoding utf-8
if exists('g:loaded_plugin_config_lightline_mh4pwx8p') | finish | endif
let g:loaded_plugin_config_lightline_mh4pwx8p = 1

" Definitions {{{1
" Status bar definition {{{2
let g:lightline = {
    \ 'tabline': {
    \   'left':
    \   [
    \       [ 'buffers' ],
    \   ],
    \   'right':
    \   [
    \       [ 'filesize' ],
    \   ],
    \ },
    \ 'active': {
    \   'left':
    \    [
    \       [ 'vim_mode', 'paste' ],
    \       [ 'filename' ],
    \       [ 'git_status', 'linter_checking', 'linter_errors', 'linter_warnings', 'coc_status'],
    \    ],
    \   'right':
    \    [
    \       [ 'line_info' ],
    \       [ 'filetype_icon', 'fileencoding_non_utf', 'fileformat_icon' ],
    \       [ 'current_tag' ],
    \       [ 'asyncrun_status' ],
    \    ]
    \ },
    \ 'inactive': {
    \      'left':
    \       [
    \           [ 'filename' ]
    \       ],
    \      'right':
    \       [
    \           [ 'line_info' ],
    \           [ 'filetype_icon', 'fileencoding_non_utf', 'fileformat_icon' ],
    \       ]
    \ },
    \ 'component': {
    \   'filename': '%<%{LL_FileName()}',
    \ },
    \ 'component_function': {
    \   'git_status': 'LL_GitStatus',
    \   'filesize': 'LL_FileSize',
    \   'filetype_icon': 'LL_FileType',
    \   'fileformat_icon': 'LL_FileFormat',
    \   'fileencoding_non_utf': 'LL_FileEncoding',
    \   'line_info': 'LL_LineInfo',
    \   'vim_mode': 'LL_Mode',
    \   'venv': 'LL_VirtualEnvName',
    \   'current_tag': 'LL_CurrentTag',
    \   'coc_status': 'LL_CocStatus',
    \   'asyncrun_status': 'LL_AsyncRunStatus',
    \ },
    \ 'tab_component_function': {
    \   'filename': 'LL_TabName',
    \ },
    \ 'component_expand': {
    \   'linter_checking': 'lightline#ale#checking',
    \   'linter_warnings': 'LL_LinterWarnings',
    \   'linter_errors': 'LL_LinterErrors',
    \   'linter_ok': 'lightline#ale#ok',
    \   'buffers' : 'lightline#bufferline#buffers',
    \ },
    \ 'component_type': {
    \   'readonly': 'error',
    \   'linter_checking': 'left',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'left',
    \   'buffers': 'tabsel',
    \   'cocerror': 'error',
    \   'cocwarn': 'warn',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '|', 'right': '|' },
    \ }

" Window widths {{{2
let g:LL_MinWidth = 90                                          " Width for using some expanded sections
let g:LL_MedWidth = 140                                         " Secondary width for some sections
let g:LL_MaxWidth = 200                                         " Largest width for some (unnecessary) sections

" Symbols/glyphs {{{2
let g:LL_pl = get(g:, 'LL_pl', 0)
let g:LL_nf = get(g:, 'LL_nf', 0)
let g:LL_LineNoSymbol = ''                                     " Use  for line; alt: '␤'
let g:LL_GitSymbol = g:LL_nf ? ' ' : ''                        " Use git symbol unless no nerd fonts
let g:LL_BranchSymbol = ''                                    " Git branch symbol
let g:LL_LineSymbol = '☰ '                                      " Is 'Ξ' ever needed?
let g:LL_ROSymbol = g:LL_pl ? ' ' : '--RO-- '                  " Read-only symbol
let g:LL_ModSymbol = ' [+]'                                     " File modified symbol
let g:LL_SimpleSep = $SUB ==# '|' ? 1 : 0                       " Use simple section separators instead of PL (no other effects)
let g:LL_FnSymbol = 'ƒ '                                        " Use for current function

" Linter indicators
let g:LL_LinterChecking = g:LL_nf ? "\uf110 " : '...'
let g:LL_LinterWarnings = g:LL_nf ? "\uf071 " : '•'
let g:LL_LinterErrors = g:LL_nf ? "\uf05e " : '•'
let g:LL_LinterOK = ''

" if g:LL_nf == 1
"     packadd vim-devicons
" endif

" lightline#bufferline {{{2
let g:lightline#bufferline#enable_devicons = g:LL_nf            " Show devicons in buffer name
let g:lightline#bufferline#unicode_symbols = 1                  " Show unicode instead of ascii for readonly and modified
let g:lightline#bufferline#show_number  = 1
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" lightline#ale {{{2
let g:lightline#ale#indicator_checking = g:LL_LinterChecking
let g:lightline#ale#indicator_warnings = g:LL_LinterWarnings
let g:lightline#ale#indicator_errors = g:LL_LinterErrors
let g:lightline#ale#indicator_ok = g:LL_LinterOK

" Autocommand for lightline#update {{{2
augroup lightline_update
    autocmd!
    autocmd User CocDiagnosticChange
        \ if exists('*lightline#update')
        \ | call lightline#update() | endif
augroup END

" Section separators {{{2
function! LL_Separator(side) abort
    if !g:LL_pl || g:LL_SimpleSep
        return ''
    elseif a:side ==? 'left'
        return ''
    elseif a:side ==? 'right'
        return ''
    else
        return ''
    end
endfunction

function! LL_Subseparator(side) abort
    if !g:LL_pl || g:LL_SimpleSep
        return '|'
    elseif a:side ==? 'left'
        return ''
    elseif a:side ==? 'right'
        return ''
    else
        return ''
    endif
endfunction

let g:lightline.separator.left = LL_Separator('left')
let g:lightline.separator.right = LL_Separator('right')
let g:lightline.subseparator.left = LL_Subseparator('left')
let g:lightline.subseparator.right = LL_Subseparator('right')

" Component functions {{{1
function! LL_Mode() abort "{{{2
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
    if winwidth(0) > g:LL_MedWidth
        " No abbreviation
        let l:mode_out = l:mode[0]
    elseif winwidth(0) > g:LL_MinWidth
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

function! LL_AsyncJobStatus() abort "{{{2
    let l:status = get(g:, 'asyncrun_status', '')
    return l:status
endfunction

function! LL_LineInfo() abort "{{{2
    return s:is_not_file() ? '' :
        \ printf('%s %s %s %s :%s',
        \ s:line_percent(),
        \ LL_LinePos(),
        \ s:line_no(),
        \ g:LL_LineNoSymbol,
        \ s:col_no()
        \ )
endfunction

function! LL_LinePos() abort "{{{2
    let l:line_no_indicator_chars = ['⎺', '⎻', '─', '⎼', '⎽']
    " Zero index line number so 1/3 = 0, 2/3 = 0.5, and 3/3 = 1
    let l:current_line = line('.') - 1
    let l:total_lines = line('$') - 1

    if l:current_line == 0
        let l:index = 0
    elseif l:current_line == l:total_lines
        let l:index = -1
    else
        let l:line_no_fraction = floor(l:current_line) / floor(l:total_lines)
        let l:index = float2nr(l:line_no_fraction * len(l:line_no_indicator_chars))
    endif

    return l:line_no_indicator_chars[l:index]
endfunction
function! LL_FileType() abort "{{{2
    let l:ftsymbol = g:LL_nf &&
        \ exists('*WebDevIconsGetFileTypeSymbol') ?
        \ ' '.WebDevIconsGetFileTypeSymbol() :
        \ ''
    let l:venv = LL_VirtualEnvName()
    if winwidth(0) > g:LL_MedWidth
        return &filetype.l:ftsymbol.l:venv
    elseif winwidth(0) > g:LL_MinWidth
        let l:ext = expand('%:e')
        return &filetype ==# 'help' ? 'help' : expand('%:e')
    endif
    return ''
endfunction

function! LL_FileFormat() abort "{{{2
    let ffsymbol = g:LL_nf &&
        \ exists('*WebDevIconsGetFileFormatSymbol') ?
        \ WebDevIconsGetFileFormatSymbol() :
        \ ''
    " No output if fileformat is unix (standard)
    return &fileformat !=? 'unix' ?
            \ s:is_not_file() ?
            \ '' : winwidth(0) > g:LL_MedWidth
            \ ? (&fileformat . ' ' . ffsymbol )
            \ : ''
        \ : ''
endfunction

function! s:is_not_file() abort "{{{2
    " Return true if not treated as file
    let exclude = [
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
        \ ]
    if index(exclude, &filetype) > -1
        \ || index(exclude, expand('%:t')) > -1
        \ || index(exclude, expand('%')) > -1
        return 1
    endif
    return 0
endfunction

function! s:modified() abort "{{{2
    return &filetype =~? 'help\|vimfiler' ? '' : &modified ? g:LL_ModSymbol : &modifiable ? '' : '-'
endfunction

function! s:read_only() abort "{{{2
    return &filetype !~? 'help' && &readonly ? g:LL_ROSymbol : ''
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

function! LL_FileName() abort "{{{2
    if s:is_not_file() | return '' | endif
    let special = s:is_special_file()
    if special != -1 | return special | endif

    let f = @%
    let s = expand('%:t')
    let ww = winwidth(0)
    if ww > g:LL_MinWidth
        " Get full path and truncate gracefully
        let p = substitute(f, expand('~'), '~', '')
        let s = p
        let chars = ww <= g:LL_MedWidth ? 2 :
            \ ww <= g:LL_MaxWidth ? 3 :
            \ 999 " No truncation
        if chars < 999
            if !empty(LL_CocStatus()) | let chars -= 1 | endif
            let Shorten = { part -> part[0:chars - 1] }
            let parts = split(p, '/')
            let i = 1
            if len(parts) > 1
                for part in parts
                    if i == 1
                        let s = Shorten(part, chars)
                    elseif i == len(parts)
                        let s = s.'/'.part
                    else
                        let s = s.'/'.Shorten(part, chars)
                    endif
                    let i += 1
                endfor
            endif
        endif
    endif
    return printf('%s%s%s',
        \ s:read_only(),
        \ s,
        \ s:modified()
        \ )
endfunction

function! LL_FileSize() abort "{{{2
    let div = 1024.0
    let num = getfsize(expand(@%))
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

function! LL_FileEncoding() abort "{{{2
    " Only return a value if != utf-8
    return &fileencoding !=? 'utf-8' ? &fileencoding : ''
endfunction

function! LL_TabName() abort "{{{2
  let fname = @%
  return fname =~? '__Tagbar__' ? 'Tagbar' :
        \ fname =~? 'NERD_tree' ? 'NERDTree' :
        \ LL_FileName()
endfunction

function! LL_GitHunkSummary() abort "{{{2
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

function! LL_GitBranch() abort "{{{2
    if exists('g:coc_git_status')
        return g:coc_git_status
    elseif exists('*fugitive#head')
        return g:LL_BranchSymbol.' '.fugitive#head()
    endif
    return ''
endfunction

function! LL_GitStatus() abort "{{{2
    if !s:is_not_file() && winwidth(0) > g:LL_MinWidth
        let branch = LL_GitBranch()
        let hunks = LL_GitHunkSummary()
        return branch !=# '' ? printf('%s%s%s',
            \ g:LL_GitSymbol,
            \ branch,
            \ hunks !=# '' ? ' '.hunks : ''
            \ ) : ''
    endif
    return ''
endfunction

function! LL_VirtualEnvName() abort "{{{2
    if exists('g:did_coc_loaded') | return '' | endif
    return &filetype ==# 'python' && !empty($VIRTUAL_ENV)
        \ ? printf(' (%s)', split($VIRTUAL_ENV, '/')[-1])
        \ : ''
endfunction

function! LL_CurrentTag() abort "{{{2
    if winwidth(0) < g:LL_MaxWidth | return '' | endif
    let coc_func = get(b:, 'coc_current_function', '')
    if coc_func !=# '' | return coc_func | endif
    if exists('*tagbar#currenttag')
        return tagbar#currenttag('%s', '', 'f')
    endif
    return ''
endfunction

function! LL_CocStatus() abort "{{{2
    if winwidth(0) > g:LL_MinWidth && get(g:, 'did_coc_loaded', 0)
        return get(g:, 'coc_status', '')
    endif
    return ''
endfunction

function! s:coc_error() abort "{{{2
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    return ''
  endif
  let errmsgs = []
  if get(info, 'error', 0)
    call add(errmsgs, g:LL_LinterErrors . info['error'])
  endif
  return trim(join(errmsgs, ' ') . ' ')
endfunction

function! s:coc_warn() abort " {{{2
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info)
    return ''
  endif
  let warnmsgs = []
  if get(info, 'warning', 0)
    call add(warnmsgs, g:LL_LinterWarnings . info['warning'])
  endif
  return trim(join(warnmsgs, ' ') . ' ')
endfunction

function! LL_LinterErrors() abort " {{{2
    let coc = s:coc_error()
    return empty(coc) ?
        \ lightline#ale#errors() :
        \ coc
endfunction

function! LL_LinterWarnings() abort " {{{2
    let coc = s:coc_warn()
    return empty(coc) ?
        \ lightline#ale#warnings() :
        \ coc
endfunction

" Theme {{{1
if !empty(get(g:, 'statusline_theme'))
    let lightline['colorscheme'] = g:statusline_theme
endif
