if exists('g:loaded_sneak_vim_config')
    finish
endif
let g:loaded_sneak_vim_config = 1

" Act similar 
let g:sneak#label = 1

" Get current bg highlight
" let s:normal_bg = nick#functions#extract_highlight('Normal', 'bg', 'cterm')
let s:normal_bg = 234

" Change default ugly magenta highlight
execute printf('highlight Sneak ctermfg=red ctermbg=%d', s:normal_bg)
" highlight Sneak ctermfg=red ctermbg=234
