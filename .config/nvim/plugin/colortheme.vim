" ====================================================
" Filename:    plugin/colortheme.vim
" Description: Color and theme settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-02-28 18:53:17 CST
" ====================================================
let s:guard = 'g:loaded_plugin_colortheme' | if exists(s:guard) | finish | endif
let {s:guard} = 1

" TMUX: make it work with termguicolors
if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Map colorscheme -> statusline theme
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

" Assign colorscheme
function! s:get_vim_color() abort
    if has('nvim')
        return !empty($NVIM_COLOR) ? $NVIM_COLOR : 'papercolor-dark'
    else
        return !empty($VIM_COLOR) ? $VIM_COLOR : 'gruvbox-dark'
    endif
endfunction

let g:vim_color = s:get_vim_color()

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

if !empty(get(g:, 'vim_base_color'))
    execute 'silent! colorscheme ' g:vim_base_color

    if !empty(get(g:, 'vim_color')) && !empty(get(g:, 'airline_themes'))
        let g:statusline_theme = get(g:airline_themes, g:vim_color, g:vim_base_color)
        " Set airline theme
        let g:airline_theme = tolower(g:statusline_theme)
    endif
endif

" if !empty(get(g:, 'statusline_theme'))
"     let g:lightline.colorscheme = g:statusline_theme
" endif
" vim:fdl=1:
