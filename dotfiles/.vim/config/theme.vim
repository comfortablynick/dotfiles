" Colors/themes

set termguicolors                       " Show true colors

if has('nvim')
    set background=dark
    colorscheme PaperColor
    let g:airline_theme = 'papercolor'     " Airline theme (separate from vim)
else
    set background=dark
    colorscheme nord
endif

" Ayucolor
" https://github.com/ayu-theme/ayu-colors
let ayucolor = 'mirage'                 " For ayu theme

" Nord
" https://github.com/arcticicestudio/nord-vim
let g:nord_italic = 1                   " Support italic fonts
let g:nord_italic_comments = 1          " Italic comments
let g:nord_comment_brightness = 10
let g:nord_cursor_line_number_background = 1

" Gruvbox Theme
" https://github.com/morhetz/gruvbox
let g:gruvbox_italic = 0                " Support italic fonts

" PaperColor Theme
" https://github.com/NLKNguyen/papercolor-theme
"
" Setting transparent_background may help in Termius SSH
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
