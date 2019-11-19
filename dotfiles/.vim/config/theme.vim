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
    \ 'PaperColor-dark': 'oneish',
    \ 'gruvbox': 'gruvbox',
    \ }
" Vim / Neovim Theme {{{1
" Set theme options/overrides {{{2
let g:PaperColor_Theme_Options = {
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     },
  \     'cpp': {
  \       'highlight_standard_library': 1
  \     },
  \     'c': {
  \       'highlight_builtins' : 1
  \     }
  \   },
  \   'theme': {
  \     'default': {
  \       'allow_bold': 1,
  \       'allow_italic': 1,
  \     },
  \     'default.dark': {
  \       'override' : {
  \         'vertsplit_bg': ['#808080', '244'],
  \       }
  \     }
  \   }
  \ }

" Set colors based on theme {{{2
" Assign to variables
execute 'silent! colorscheme' g:vim_base_color
let &background = g:vim_color_variant
let g:statusline_theme = get(g:airline_themes, vim_color, g:vim_base_color)

" Set airline theme
let g:airline_theme = tolower(g:statusline_theme)
