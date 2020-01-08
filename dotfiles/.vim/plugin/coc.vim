" ====================================================
" Filename:    plugin/coc.vim
" Description: Coc (au)commands and some settings
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-08 12:44:00 CST
" ====================================================
if exists('g:loaded_plugin_config_coc_s5zywzm2')
    \ || exists('g:no_load_packages')
    finish
endif
let g:loaded_plugin_config_coc_s5zywzm2 = 1

" Call func to set autocmds if LC is loaded
augroup plugin_config_coc_s5zywzm2
    autocmd!
    autocmd User CocNvimInit call config#coc#init()
augroup END

if exists('g:completion_filetypes')
    let coc_filetypes = join(get(g:, 'completion_filetypes', {})['coc'], ',')

    if !empty(coc_filetypes)
        execute printf('autocmd plugin_config_coc_s5zywzm2 FileType %s silent! packadd coc.nvim',
            \ coc_filetypes)
    endif
endif
