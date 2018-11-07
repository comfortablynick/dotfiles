" VIM COLORS/THEMES

" SSH Compatibility {{{
" Remove background to try to work better with iOS SSH apps
if !empty($SSH_CONNECTION) && $VIM_SSH_COMPAT == 1
    hi Normal guibg=NONE ctermbg=NONE
    hi nonText guibg=NONE ctermbg=NONE
    let g:LL_pl = 0
else
    let g:LL_pl = 1
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
  \       'transparent_background': 1
  \     },
  \     'default.dark': {
  \       'transparent_background': 1
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
    \ 'gruvbox': 'gruvbox',
    \ }
" }}}
" Lightline {{{
let g:lightline = {
		\ 'active': {
		\   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
		\ },
		\ 'component_function': {
		\   'fugitive': 'LightlineFugitive',
		\   'filename': 'LightlineFilename'
		\ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '', 'right': '' },
		\ }

" Section Functions
function! LL_LSep()
    return g:LL_pl == 1 ? '' : ''
endfunction

function! LL_RSep()
    return g:LL_pl == 1 ? '' : ''
endfunction

function! LL_LSubSep()
    return g:LL_pl == 1 ? '' : '|'
endfunction

function! LL_Branch()
    return g:LL_pl == 1 ? ' ' : '🜉 '
endfunction

function! LL_LineNo()
    return g:LL_pl == 1 ? '' : '␤'
endfunction
function! LL_RSubSep()
    return g:LL_pl == 1 ? '' : '|'
endfunction

function! LL_Compat()
    return g:
endfunction
function! LightlineModified()
    return &ft =~ 'help\|vimfiler' ? '' : &modified ? '[+]' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
    return &ft !~? 'help\|vimfiler' && &readonly ? '⭤' : ''
endfunction

function! LightlineFilename()
    return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
    \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
    \  &ft == 'unite' ? unite#get_status_string() :
    \  &ft == 'vimshell' ? vimshell#get_status_string() :
    \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
    \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
    if &ft !~? 'vimfiler' && exists('*fugitive#head')
        let branch = fugitive#head()
        return branch !=# '' ? LL_Branch().branch : ''
    endif
    return ''
endfunction
" }}}
" Vim / Neovim Settings {{{
set termguicolors                                               " Show true colors

" Get color theme from env var
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

" Set colors based on theme
" vim_baseColor: 'nord-dark' -> 'nord'
let vim_baseColor = substitute(vim_color, '-dark\|-light', '', '')

" vim_variant: 'nord-dark' -> 'dark'
let vim_variant = substitute(vim_color, vim_baseColor . '-', '', '')

" Assign to variables
exe "colorscheme ".vim_baseColor
exe "set background=".vim_variant
let g:airline_theme = get(airline_themes, vim_color, vim_baseColor)

" Lightline
let g:lightline.separator.left = LL_LSep()
let g:lightline.separator.right = LL_RSep()
let g:lightline.subseparator.left = LL_LSubSep()
let g:lightline.subseparator.right = LL_RSubSep()
let lightline['colorscheme'] = airline_theme
" }}}
