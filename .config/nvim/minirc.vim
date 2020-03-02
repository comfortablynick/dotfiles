" Minimal vimrc
" Use to debug config
" Place any packages in ~/plugin/pack/*/start
set runtimepath=/etc/xdg/nvim,/usr/local/share/nvim/site,/usr/share/nvim/site,/usr/share/nvim/runtime,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/etc/xdg/nvim/after
set packpath=~/plugin,~/plugin/after
set foldmethod=marker
syntax on
filetype plugin indent on

" au SourcePre *coc* source ~/.config/nvim/autoload/plugins/coc.vim
" Autocmds {{{2
augroup plugin_config_handler
    autocmd!
    autocmd! SourcePre * call s:source_handler(expand('<afile>'), 'pre')
    autocmd! SourcePost * call s:source_handler(expand('<afile>'), 'post')
augroup END

let g:plugin_config_files = map(
    \ globpath(&runtimepath, 'autoload/plugins/*', 0, 1),
    \ {_, val -> fnamemodify(val, ':t:r')}
    \ )

" Debug Variables {{{2
let g:plugins_sourced = []
let g:plugins_skipped = []
let g:plugins_called = []
let g:plugins_missing_fns = []
let g:sourced_all = []
let g:source_cmd = []

function! s:source_handler(sourced, type) abort "{{{2
    let l:file = fnamemodify(a:sourced, ':t:r')
    let l:full_path = fnamemodify(a:sourced, ':p')
    let g:sourced_all += [l:full_path]
    " if l:full_path !~# 'pack/[^/]*/\(start\|opt\)/[^/]*/\(plugin\|autoload\)/'
    "     " if a:sourced =~# '^[plugin|autoload]'
    "     let g:plugins_skipped += [l:full_path]
    "     return
    " endif
    if a:type ==# 'pre'
        let g:plugins_sourced += [a:sourced]
        let g:plugins_called += [l:file]
    endif
    " if index(g:plugin_config_files, l:file) > -1
        let l:fn = 'plugins#'.l:file.'#'.a:type
        if !exists('*'.l:fn)
            execute 'runtime autoload/plugins/'.l:file.'.vim'
        endif
        if exists('*'.l:fn)
            call {l:fn}()
        else
            let g:plugins_missing_fns += [l:fn]
        endif
    " endif
endfunction
