" vim:fdl=1:
"  _   _                               _
" | |_| |__   ___ _ __ ___   _____   _(_)_ __ ___
" | __| '_ \ / _ \ '_ ` _ \ / _ \ \ / / | '_ ` _ \
" | |_| | | |  __/ | | | | |  __/\ V /| | | | | | |
"  \__|_| |_|\___|_| |_| |_|\___(_)_/ |_|_| |_| |_|

" Vim Themes / Statusline
scriptencoding utf-8
" Terminal client compatibility {{{1
" SSH: remove background to try to work better with iOS SSH apps {{{2
" if $VIM_SSH_COMPAT == 1
"     hi Normal guibg=NONE ctermbg=NONE
"     hi nonText guibg=NONE ctermbg=NONE
"     let g:LL_nf = 0
"     set notermguicolors
" endif

" " FONTS: check env vars to see if we need to turn off fancy fonts {{{2
" if ! empty($POWERLINE_FONTS) && $POWERLINE_FONTS == 0
"     " We can turn off both, since NF are a superset of PL fonts
"     let g:LL_nf = 0
"     let g:LL_pl = 0
" elseif ! empty($NERD_FONTS) && $NERD_FONTS == 0
"     " Disable NF but keep PL fonts (iOS SSH apps, etc.)
"     let g:LL_nf = 0
"     let g:LL_pl = 1
" endif

" TMUX: make it work with termguicolors {{{2
if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" " Get color theme from env var {{{2
" function! s:get_color_theme() abort
"     return has('nvim') ?
"         \ !empty('$NVIM_COLOR') ? $NVIM_COLOR : 'papercolor-dark' :
"         \ !empty('$VIM_COLOR') ? $VIM_COLOR : 'gruvbox-dark'
" endfunction
" let g:vim_color = s:get_color_theme()

" g:vim_base_color: 'nord-dark' -> 'nord'
let g:vim_base_color = substitute(
    \ g:vim_color,
    \ '-dark\|-light',
    \ '',
    \ '')

" g:vim_color_variant: 'nord-dark' -> 'dark'
let g:vim_color_variant = substitute(
    \ g:vim_color,
    \ g:vim_base_color . '-',
    \ '',
    \ '')

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
    \ 'onedark': 'onedark',
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
