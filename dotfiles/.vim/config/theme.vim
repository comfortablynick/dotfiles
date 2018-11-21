" VIM COLORS/THEMES

" Theme Compatibility {{{
" Defaults: turn all fonts and colors ON
let g:LL_pl = 1
let g:LL_nf = 1
set termguicolors

" SSH: remove background to try to work better with iOS SSH apps
if $VIM_SSH_COMPAT == 1
    hi Normal guibg=NONE ctermbg=NONE
    hi nonText guibg=NONE ctermbg=NONE
    let g:LL_nf = 0
    set notermguicolors
endif

" FONTS: check env vars to see if we need to turn off nerd/powerline fonts
if ! empty($POWERLINE_FONTS) && $POWERLINE_FONTS == 0
    " We can turn off both, since NF are a superset of PL fonts
    let g:LL_nf = 0
    let g:LL_pl = 0
elseif ! empty($NERD_FONTS) && $NERD_FONTS == 0
    " Disable NF but keep PL fonts (iOS SSH apps, etc.)
    let g:LL_nf = 0
    let g:LL_pl = 1
endif

" TMUX: make it work with termguicolors
if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
" }}}
" Theme: Nord {{{
" (https://github.com/arcticicestudio/nord-vim)
let g:nord_italic = 1                                           " Support italic fonts
let g:nord_italic_comments = 0                                  " Italic comments
let g:nord_underline = 1                                        " Support underline where possible
let g:nord_comment_brightness = 10                              " Controls % brightness
let g:nord_cursor_line_number_background = 1                    " Extend highlighted line into the ln column
" }}}
" Theme: Gruvbox {{{
" (https://github.com/morhetz/gruvbox)
let g:gruvbox_italic = 0                                        " Support italic fonts
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_contrast_light = 'soft'
let g:gruvbox_improved_strings = 0
" }}}
" Theme: PaperColor {{{
" https://github.com/NLKNguyen/papercolor-theme
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'allow_bold': 1,
  \       'allow_italic': 0,
  \       'transparent_background': 0
  \     },
  \     'default.dark': {
  \       'transparent_background': 0
  \     }
  \   },
  \  'language': {
  \    'python': {
  \      'highlight_builtins': 1
  \      }
  \   }
  \ }
" }}}
" Airline {{{
" Map colorscheme to airline theme
let g:airline_themes = {
    \ 'nord': 'nord',
    \ 'snow-dark': 'snow_dark',
    \ 'snow-light': 'snow_light',
    \ 'papercolor': 'papercolor',
    \ 'PaperColor': 'PaperColor',
    \ 'gruvbox': 'gruvbox',
    \ }
" }}}
" Lightline {{{
" Status bar definition {{{
let g:lightline = {
    \ 'active': {
    \   'left':
    \     [
    \        [ 'vim_mode', 'paste' ],
    \        [ 'fugitive' ],
    \        [ 'filename' ],
    \     ],
    \   'right':
    \     [
    \        [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
    \        [ 'line_info' ],
    \        [ 'filetype_icon', 'fileencoding_non_utf', 'fileformat_icon' ],
    \     ]
    \ },
    \ 'inactive': {
    \      'left':
    \     [
    \        [ 'filename' ]
    \     ],
    \      'right':
    \     [
    \        [ 'line_info' ],
    \        [ 'filetype_icon', 'fileencoding_non_utf', 'fileformat_icon' ],
    \     ]
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
    \ },
    \ 'component_expand': {
    \   'linter_checking': 'lightline#ale#checking',
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok'
    \ },
    \ 'component_type': {
    \   'readonly': 'error',
    \   'linter_checking': 'left',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'left'
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' },
    \ }
" }}}
" Section definitions {{{
" ALE Indicators {{{
let g:lightline#ale#indicator_checking = g:LL_nf ? "\uf110" : '...'
let g:lightline#ale#indicator_warnings = g:LL_nf ? "\uf071 " : '⧍'
let g:lightline#ale#indicator_errors = g:LL_nf ? "\uf05e " : '✗'
let g:lightline#ale#indicator_ok = g:LL_nf ? "\uf00c" : '✓'
" }}}
" Main sections {{{
" Section settings / glyphs {{{
let g:LL_MinWidth = 90                                          " Width for using some expanded sections
let g:LL_MedWidth = 100                                         " Secondary width for some sections
let g:LL_LineNoSymbol = g:LL_pl ? '' : '␤'                     " Use  for line no unless no PL fonts
let g:LL_GitSymbol = g:LL_nf ? ' ' : ''                         " Use git symbol unless no nerd fonts
let g:LL_Branch = g:LL_pl ? '' : ''                           " Use git branch NF symbol (is '🜉' ever needed?)
let g:LL_LineSymbol = g:LL_pl ? '☰ ' : '☰ '                     " Is 'Ξ' ever needed?
let g:LL_ROSymbol = g:LL_pl ? '' : '--RO--'                    " Read-only PL symbol
" }}}
" Section separators {{{
let g:lightline.separator.left = g:LL_pl ? '' : ''
let g:lightline.separator.right = g:LL_pl ? '' : ''
let g:lightline.subseparator.left = g:LL_pl ? '' : '|'
let g:lightline.subseparator.right = g:LL_pl ? '' : '|'
" }}}
function! LL_Modified() abort " {{{
    return &ft =~ 'help\|vimfiler' ? '' : &modified ? '[+]' : &modifiable ? '' : '-'
endfunction
" }}}
function! LL_Mode() abort " {{{
    " TODO: abbreviate mode if < MinWidth
    return LL_IsNerd() ? 'NERD' : lightline#mode()
endfunction
" }}}
function! LL_IsNotFile() abort " {{{
    " Return true if not treated as file
    let exclude = [
        \ 'gitcommit',
        \ 'NERD_tree',
        \ 'output',
        \ ]
    for item in exclude
        if &ft =~ item || expand('%:t') =~ item
            return 1
            break
        else
            continue
        endif
    endfor
endfunction
" }}}
function! LL_LinePercent() abort " {{{
    return printf("%3d%%", line('.') * 100 / line('$'))
endfunction
" }}}
function! LL_LineNo() abort " {{{
    let totlines = line('$')
    let maxdigits = len(string(totlines))
    return printf("%*d/%*d",
        \ maxdigits,
        \ line('.'),
        \ maxdigits,
        \ totlines
        \ )
endfunction
" }}}
function! LL_ColNo() abort " {{{
    return printf("%3d", virtcol('.'))
endfunction
" }}}
function! LL_LineInfo() abort " {{{
    return LL_IsNotFile() ? '' :
        \ printf("%s %s %s %s :%s",
        \ LL_LinePercent(),
        \ g:LL_LineSymbol,
        \ LL_LineNo(),
        \ g:LL_LineNoSymbol,
        \ LL_ColNo()
        \ )
endfunction
" }}}
function! LL_FileType() abort " {{{
    let ftsymbol = g:LL_nf &&
        \ exists('*WebDevIconsGetFileTypeSymbol') ?
        \ ' '.WebDevIconsGetFileTypeSymbol() :
        \ ''
    let venv = &ft == 'python' ?
        \ ' ('.LL_VirtualEnvName().')' :
        \ ''
    return winwidth(0) > g:LL_MinWidth ? (&ft . ftsymbol .venv ) : ''
endfunction
" }}}
function! LL_FileFormat() abort " {{{
    let ffsymbol = g:LL_nf &&
        \ exists('*WebDevIconsGetFileFormatSymbol') ?
        \ WebDevIconsGetFileFormatSymbol() :
        \ ''
    return LL_IsNotFile() ? '' : winwidth(0) > g:LL_MedWidth ? (&fileformat . ' ' . ffsymbol ) : ''
endfunction
" }}}
function! LL_FileEncoding() abort " {{{
    " Only return a value if != utf-8
    return &fileencoding != 'utf-8' ? &fileencoding : ''
endfunction
" }}}
function! LL_HunkSummary() abort " {{{
    let githunks = GitGutterGetHunkSummary()
    return printf("+%d ~%d -%d",
        \ githunks[0],
        \ githunks[1],
        \ githunks[2]
        \ )
endfunction
" }}}
function! LL_ReadOnly() abort " {{{
    return &ft !~? 'help' && &readonly ? g:LL_ROSymbol : ''
endfunction
" }}}
function! LL_IsNerd() abort " {{{
    return expand('%:t') =~ 'NERD_tree'
endfunction
" }}}
function! LL_FileName() abort " {{{
    let fname = expand('%:t')
    return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LL_ReadOnly() ? LL_ReadOnly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LL_Modified() ? ' ' . LL_Modified() : '')
endfunction
" }}}
function! LL_Fugitive() abort " {{{
    if &ft !~? 'vimfiler' && ! LL_IsNotFile() && exists('*fugitive#head') && winwidth(0) > g:LL_MinWidth
        let branch = fugitive#head()
        return branch !=# '' ? printf("%s%s %s %s",
            \ g:LL_GitSymbol,
            \ LL_HunkSummary(),
            \ g:LL_Branch,
            \ branch,
            \ ) : ''
    endif
    return ''
endfunction
" }}}
function! LL_VirtualEnvName() abort " {{{
    return !empty($VIRTUAL_ENV) ? split($VIRTUAL_ENV, '/')[-1] : ''
endfunction
" }}}
" }}}
" }}}
" }}}
" Vim / Neovim Settings {{{
" Get color theme from env var {{{
if has('nvim')
    let vim_color = $NVIM_COLOR
    if empty(vim_color)
        " Default Neovim color
        let vim_color = 'snow-dark'
    endif
else
    let vim_color = $VIM_COLOR
    if empty(vim_color)
        " Default Vim color
        let vim_color = 'gruvbox-dark'
    endif
endif
" }}}
" Set colors based on theme {{{
" vim_baseColor: 'nord-dark' -> 'nord'
let vim_baseColor = substitute(vim_color, '-dark\|-light', '', '')

" vim_variant: 'nord-dark' -> 'dark'
let vim_variant = substitute(vim_color, vim_baseColor . '-', '', '')

" Assign to variables
exe "colorscheme ".vim_baseColor
exe "set background=".vim_variant
let g:airline_theme = get(airline_themes, vim_color, vim_baseColor)
let lightline['colorscheme'] = airline_theme
" }}}
" }}}
