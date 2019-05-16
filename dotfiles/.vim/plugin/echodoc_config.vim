if exists('g:loaded_echodoc_config')
    finish
endif
let g:loaded_echodoc_config = 1

" TODO: Only execute for python/ts/js?
let g:echodoc#enable_at_startup = 1
let g:ecodoc#type = 'echo'                   " virtual: virtualtext; echo: use command line echo area
set cmdheight=1                                 " Add extra line for function definition
set noshowmode
set shortmess+=c                                " Don't suppress echodoc with 'Match x of x'
