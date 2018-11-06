" VIM COLORS/THEMES

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
" }}}
" SSH Compatibility {{{
" Remove background to try to work better with iOS SSH apps
if !empty($SSH_CONNECTION) && $VIM_SSH_COMPAT == 1
    hi Normal guibg=NONE ctermbg=NONE
    hi nonText guibg=NONE ctermbg=NONE
endif
" }}}
