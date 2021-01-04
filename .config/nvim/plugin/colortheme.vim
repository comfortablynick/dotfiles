" Set theme options/overrides
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

if !has('nvim')
    silent! colorscheme PaperColor
else
    if 1
        let s:base16 = 'monokai'
        " let s:base16 = 'mocha'
        " let s:base16 = 'gruvbox-dark-hard'
        " let s:base16 = 'irblack'
        call v:lua.require('config.theme').set_theme(s:base16)
    else
        colorscheme gruvbox8_hard
    endif
endif

finish
" Assign colorscheme {{{1
let g:vim_color = has('nvim') ? (!empty($NVIM_COLOR) ? $NVIM_COLOR : 'papercolor-dark')
    \ : (!empty($VIM_COLOR) ? $VIM_COLOR : 'gruvbox-dark')

" Map colorscheme -> statusline theme {{{1
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

" g:vim_base_color: 'nord-dark' -> 'nord'
let g:vim_base_color = substitute(
    \ g:vim_color,
    \ '-dark\|-light',
    \ '',
    \ '')

" g:vim_color_variant: 'nord-dark' -> 'dark'
let g:vim_color_variant = substitute(
    \ g:vim_color,
    \ g:vim_base_color..'-',
    \ '',
    \ '')

if !empty(get(g:, 'vim_base_color'))
    let &background = g:vim_color_variant
    execute 'silent! colorscheme' g:vim_base_color

    if !empty(get(g:, 'vim_color')) && !empty(get(g:, 'airline_themes'))
        let g:statusline_theme = get(g:airline_themes, g:vim_color, g:vim_base_color)
        " Set airline theme
        let g:airline_theme = tolower(g:statusline_theme)
    endif
endif
