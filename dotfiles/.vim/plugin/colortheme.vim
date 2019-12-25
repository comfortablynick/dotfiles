" ====================================================
" Filename:    plugin/colortheme.vim
" Description: Color and theme settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-19
" ====================================================
if exists('g:loaded_plugin_colortheme_brhrevkl') | finish | endif
let g:loaded_plugin_colortheme_brhrevkl = 1

" Vim Themes / Statusline
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

" Set theme options/overrides {{{1
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

" Change default ugly magenta highlight
function! s:add_sneak_highlights() abort
    highlight Sneak         ctermfg=red ctermbg=234 guifg=#ff0000 guibg=#1c1c1c
endfunction

augroup plugin_colortheme_brhrevkl
    autocmd!
    autocmd ColorScheme * call s:add_sneak_highlights()
augroup END

if !empty(get(g:, 'vim_base_color'))
    execute 'silent! colorscheme ' g:vim_base_color

    if !empty(get(g:, 'vim_color')) && !empty(get(g:, 'airline_themes'))
        let g:statusline_theme = get(g:airline_themes, g:vim_color, g:vim_base_color)
        " Set airline theme
        let g:airline_theme = tolower(g:statusline_theme)
    endif
endif

" vim:fdl=1:
