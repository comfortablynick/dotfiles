" vim:fdl=1:
"  _   _                               _
" | |_| |__   ___ _ __ ___   _____   _(_)_ __ ___
" | __| '_ \ / _ \ '_ ` _ \ / _ \ \ / / | '_ ` _ \
" | |_| | | |  __/ | | | | |  __/\ V /| | | | | | |
"  \__|_| |_|\___|_| |_| |_|\___(_)_/ |_|_| |_| |_|

" Vim Themes / Statusline
scriptencoding utf-8
" Airline {{{1
" Map colorscheme -> theme {{{2
let g:airline_themes = {
    \ 'nord': 'nord',
    \ 'snow-dark': 'snow_dark',
    \ 'snow-light': 'snow_light',
    \ 'papercolor': 'papercolor',
    \ 'PaperColor': 'PaperColor',
    \ 'gruvbox': 'gruvbox',
    \ 'apprentice': 'apprentice',
    \ }
" Lightline {{{1
" Status bar definition {{{2
let g:lightline = {
    \ 'tabline': {
    \   'left':
    \   [
    \       [ 'buffers' ],
    \   ],
    \   'right':
    \   [
    \       [ 'filename' ],
    \   ],
    \ },
    \ 'active': {
    \   'left':
    \    [
    \       [ 'vim_mode', 'paste' ],
    \       [ 'fugitive' ],
    \       [ 'filename' ],
    \    ],
    \   'right':
    \    [
    \       [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok', 'line_info' ],
    \       [ 'filetype_icon', 'fileencoding_non_utf', 'fileformat_icon' ],
    \       [ 'current_tag' ],
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
    \ 'component_function': {
    \   'fugitive': 'LL_Fugitive',
    \   'filename': 'LL_FileName',
    \   'filetype_icon': 'LL_FileType',
    \   'fileformat_icon': 'LL_FileFormat',
    \   'fileencoding_non_utf': 'LL_FileEncoding',
    \   'line_info': 'LL_LineInfo',
    \   'vim_mode': 'LL_Mode',
    \   'venv': 'LL_VirtualEnvName',
    \   'current_tag': 'LL_CurrentTag',
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
    \   'cocerror': 'LL_CocError',
    \   'cocwarn': 'LL_CocWarn',
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
" Section definitions {{{2
" Section settings / glyphs {{{3
let g:LL_MinWidth = 90                                          " Width for using some expanded sections
let g:LL_MedWidth = 120                                         " Secondary width for some sections
let g:LL_LineNoSymbol = g:LL_pl ? '' : ''                     " Use  for line no unless no PL fonts; alt: '␤'
let g:LL_GitSymbol = g:LL_nf ? ' ' : ''                        " Use git symbol unless no nerd fonts
let g:LL_Branch = g:LL_pl ? '' : ''                           " Use git branch NF symbol (is '🜉' ever needed?)
let g:LL_LineSymbol = g:LL_pl ? '☰ ' : '☰ '                     " Is 'Ξ' ever needed?
let g:LL_ROSymbol = g:LL_pl ? ' ' : '--RO-- '                  " Read-only symbol
let g:LL_ModSymbol = ' [+]'                                     " File modified symbol
let g:LL_SimpleSep = 0                                          " Use simple section separators instead of PL (no other effects)

" Linter indicators
let g:LL_LinterChecking = g:LL_nf ? "\uf110 " : '...'
let g:LL_LinterWarnings = g:LL_nf ? "\uf071 " : '⧍'
let g:LL_LinterErrors = g:LL_nf ? "\uf05e " : '✗'
let g:LL_LinterOK = ''

" lightline#bufferline {{{3
let g:lightline#bufferline#enable_devicons = 1                  " Show devicons in buffer name
let g:lightline#bufferline#unicode_symbols = 1                  " Show unicode instead of ascii for readonly and modified
let g:lightline#bufferline#show_number  = 2
let g:lightline#bufferline#shorten_path = 1
let g:lightline#bufferline#unnamed      = '[No Name]'
let g:lightline#bufferline#number_map = {
    \ 0: '➓ ',
    \ 1: '❶ ',
    \ 2: '❷ ',
    \ 3: '❸ ',
    \ 4: '❹ ',
    \ 5: '❺ ',
    \ 6: '❻ ',
    \ 7: '❼ ',
    \ 8: '❽ ',
    \ 9: '❾ ',
    \ }

" lightline#ale {{{3
let g:lightline#ale#indicator_checking = g:LL_LinterChecking
let g:lightline#ale#indicator_warnings = g:LL_LinterWarnings
let g:lightline#ale#indicator_errors = g:LL_LinterErrors
let g:lightline#ale#indicator_ok = g:LL_LinterOK

" Section separators {{{3
" Get separators based on settings above "{{{
function! LL_Separator(side) abort "{{{
    if !g:LL_pl || g:LL_SimpleSep
        return ''
    elseif a:side ==? 'left'
        return ''
    elseif a:side ==? 'right'
        return ''
    else
        return
    end
endfunction
"}}}
function! LL_Subseparator(side) abort "{{{
    if !g:LL_pl || g:LL_SimpleSep
        return '|'
    elseif a:side ==? 'left'
        return ''
    elseif a:side ==? 'right'
        return ''
    else
        return
    endif
endfunction
"}}}
"}}}
let g:lightline.separator.left = LL_Separator('left')
let g:lightline.separator.right = LL_Separator('right')
let g:lightline.subseparator.left = LL_Subseparator('left')
let g:lightline.subseparator.right = LL_Subseparator('right')

" Component functions {{{2
function! LL_Modified() abort "{{{3
    return &filetype =~? 'help\|vimfiler' ? '' : &modified ? g:LL_ModSymbol : &modifiable ? '' : '-'
endfunction
function! LL_Mode() abort "{{{3
    " l:mode_map (0 = full size, 1 = medium abbr, 2 = short abbr) {{{
    let l:mode_map = {
        \ 'n' : [
        \   'NORMAL',
        \   'NORM',
        \   'N',
        \ ],
        \ 'i' : [
        \   'INSERT',
        \   'INS',
        \   'I',
        \ ],
        \ 'R' : [
        \   'REPLACE',
        \   'REPL',
        \   'R',
        \ ],
        \ 'v' : [
        \   'VISUAL',
        \   'VIS',
        \   'V',
        \ ],
        \ 'V' : [
        \   'V-LINE',
        \   'V-LN',
        \   'V-L',
        \ ],
        \ "\<C-v>": [
        \   'V-BLOCK',
        \   'V-BL',
        \   'V-B',
        \ ],
        \ 'c' : [
        \   'COMMAND',
        \   'CMD',
        \   'C',
        \ ],
        \ 's' : [
        \   'SELECT',
        \   'SEL',
        \   'S',
        \ ],
        \ 'S' : [
        \   'S-LINE',
        \   'S-LN',
        \   'S-L',
        \ ],
        \ "\<C-s>": [
        \   'S-BLOCK',
        \   'S-BL',
        \   'S-B',
        \ ],
        \ 't': [
        \   'TERMINAL',
        \   'TERM',
        \   'T',
        \ ],
        \ }
    " }}}
    let l:mode = mode()
    let f = @%
    if LL_IsNerd()
        return 'NERD'
    elseif f ==? '__Tagbar__'
        return 'TAGS'
    elseif f =~? 'undotree'
        return 'UNDO'
    elseif winwidth(0) > g:LL_MedWidth
        " No abbreviation
        return l:mode_map[l:mode][0]
    elseif winwidth(0) > g:LL_MinWidth
        " Medium abbreviation
        return l:mode_map[l:mode][1]
    else
        " Short abbrevation
        return l:mode_map[l:mode][2]
    endif
endfunction

function! LL_IsNotFile() abort "{{{3
    " Return true if not treated as file
    let exclude = [
        \ 'gitcommit',
        \ 'NERD_tree',
        \ 'output',
        \ ]
    for item in exclude
        if &filetype =~? item || expand('%:t') =~ item
            return 1
            break
        else
            continue
        endif
    endfor
endfunction

function! LL_LinePercent() abort "{{{3
    return printf('%3d%%', line('.') * 100 / line('$'))
endfunction

function! LL_LineNo() abort "{{{3
    let totlines = line('$')
    let maxdigits = len(string(totlines))
    return printf('%*d/%*d',
        \ maxdigits,
        \ line('.'),
        \ maxdigits,
        \ totlines
        \ )
endfunction

function! LL_ColNo() abort "{{{3
    return printf('%3d', virtcol('.'))
endfunction

function! LL_LineInfo() abort "{{{3
    return LL_IsNotFile() ? '' :
        \ printf('%s %s %s %s :%s',
        \ LL_LinePercent(),
        \ g:LL_LineSymbol,
        \ LL_LineNo(),
        \ g:LL_LineNoSymbol,
        \ LL_ColNo()
        \ )
endfunction

function! LL_FileType() abort "{{{3
    let ftsymbol = g:LL_nf &&
        \ exists('*WebDevIconsGetFileTypeSymbol') ?
        \ ' '.WebDevIconsGetFileTypeSymbol() :
        \ ''
    let venv = LL_VirtualEnvName()
    return winwidth(0) > g:LL_MinWidth
        \ ? (&filetype . ftsymbol .venv )
        \ : ''
endfunction

function! LL_FileFormat() abort "{{{3
    let ffsymbol = g:LL_nf &&
        \ exists('*WebDevIconsGetFileFormatSymbol') ?
        \ WebDevIconsGetFileFormatSymbol() :
        \ ''
    " No output if fileformat is unix (standard)
    return &fileformat !=? 'unix' ?
            \ LL_IsNotFile() ?
            \ '' : winwidth(0) > g:LL_MedWidth
            \ ? (&fileformat . ' ' . ffsymbol )
            \ : ''
        \ : ''
endfunction

function! LL_FileEncoding() abort "{{{3
    " Only return a value if != utf-8
    return &fileencoding !=? 'utf-8' ? &fileencoding : ''
endfunction

function! LL_HunkSummary() abort "{{{3
    let githunks =  GitGutterGetHunkSummary()
    let added =     githunks[0] ? printf('+%d ', githunks[0])   : ''
    let changed =   githunks[1] ? printf('~%d ', githunks[1])   : ''
    let deleted =   githunks[2] ? printf('-%d ', githunks[2])   : ''
    return added . changed . deleted
endfunction

function! LL_ReadOnly() abort "{{{3
    return &filetype !~? 'help' && &readonly ? g:LL_ROSymbol : ''
endfunction

function! LL_IsNerd() abort "{{{3
    return expand('%:t') =~? 'NERD_tree'
endfunction

function! LL_FileName() abort "{{{3
    let f = @%
    let b = &buftype
    if empty(@%)
        return '[No Name]'
    elseif f ==? '__Tagbar__'
        return ''
    elseif f =~? '__Gundo\|NERD_tree'
        return ''
    elseif b ==? 'quickfix'
        return '[Quickfix List]'
    elseif b =~? '^\%(nofile\|acwrite\|terminal\)$'
        return empty(f) ? '[Scratch]' : f
    elseif b ==? 'help'
        return fnamemodify(f, ':t')
    else
        " Regular filename
        " Shorten it gracefully
        let p = substitute(f, expand('~'), '~', '')
        let s = p
        let numChars = winwidth(0) <= g:LL_MinWidth ? 1 :
            \ winwidth(0) <= g:LL_MedWidth ? 2 : 999
        if winwidth(0) <= g:LL_MedWidth
            let parts = split(p, '/')
            let i = 1
            for part in parts
                if i == 1
                    let s = part
                elseif i == len(parts)
                    let s = s.'/'.part
                else
                    let s = s.'/'.part[0:numChars - 1]
                endif
                let i += 1
            endfor
        endif
        return LL_ReadOnly().s.LL_Modified()
    endif
endfunction

function! LL_TabName() abort "{{{3
  let fname = @%
  return fname =~? '__Tagbar__' ? 'Tagbar' :
        \ fname =~? 'NERD_tree' ? 'NERDTree' :
        \ LL_FileName()
endfunction

function! LL_Fugitive() abort "{{{3
    if &filetype !~? 'vimfiler' && ! LL_IsNotFile() && exists('*fugitive#head') && winwidth(0) > g:LL_MinWidth
        let branch = fugitive#head()
        return branch !=# '' ? printf('%s%s%s %s',
            \ g:LL_GitSymbol,
            \ LL_HunkSummary(),
            \ g:LL_Branch,
            \ branch,
            \ ) : ''
    endif
    return ''
endfunction

function! LL_VirtualEnvName() abort "{{{3
    return &filetype ==# 'python' && !empty($VIRTUAL_ENV)
        \ ? printf(' (%s)', split($VIRTUAL_ENV, '/')[-1])
        \ : ''
endfunction

function! LL_CurrentTag() abort "{{{3
    if exists('*tagbar#currenttag') && winwidth(0) > g:LL_MedWidth
        return tagbar#currenttag('[%s]', '', 'f')
    end
    return ''
endfunction

function! LL_CocError() abort "{{{3
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

function! LL_CocWarn() abort " {{{3
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

function! LL_LinterErrors() abort " {{{3
    return LL_CocError() ==# '' ?
        \ lightline#ale#errors() :
        \ LL_CocError()
endfunction

function! LL_LinterWarnings() abort " {{{3
    return LL_CocWarn() ==# '' ?
        \ lightline#ale#warnings() :
        \ LL_CocWarn()
endfunction

" Vim / Neovim Theme {{{1
" Set colors based on theme {{{2
" Assign to variables
exe 'colorscheme '.g:vim_base_color
exe 'set background='.g:vim_color_variant
let g:statusline_theme = get(g:airline_themes, vim_color, g:vim_base_color)

" Set airline theme
let g:airline_theme = tolower(g:statusline_theme)

" Set lightline theme
let lightline['colorscheme'] = g:statusline_theme

" Tmuxline {{{1
" Tmuxline preset {{{2
let g:tmuxline_preset = {
    \'a'       : '#S',
    \'win'     : ['#I #F', '#W'],
    \'cwin'    : ['#I #F', '#W'],
    \'x'       : '#(tmux-mem-cpu-load -c -q -m 2 -g 0 -i 2)',
    \'y'       : ['%m-%d-%Y', '%l:%M %p'],
    \'z'       : '#(whoami)@#H',
    \'options' : {'status-justify' : 'left'}}

"    \'c'       : '#(tmux-mem-cpu-load -p -m 2 -g 0 -i 2)',
"    \'x'       : '#(cd #{pane_current_path}; git rev-parse --abbrev-ref HEAD)',
