" ====================================================
" Filename:    autoload/pack
" Description: Shim interface to package managers for consistency
" Author:      Nick Murphy (comfortablynick@gmail.com)
" License:     MIT
" ====================================================
let s:guard = 'g:loaded_autoload_pack' | if exists(s:guard) | finish | endif
let {s:guard} = 1

augroup autoload_pack
    autocmd!
augroup END

" Package manager wrapper functions
function! pack#init() abort "{{{1
    let l:pack_dir = get(g:, 'package_path', expand(has('nvim') ? '$XDG_DATA_HOME/nvim/site' : '$HOME/.vim'))
    let g:package_manager = get(g:, 'package_manager', 'minpac')
    if g:package_manager ==# 'minpac'
        " Check if minpac already initialized
        if exists('g:minpac#opt') | return | endif

        " Clone minpac if doesn't exist
        let l:minpac_path = get(g:, 'minpac_path', expand('$XDG_DATA_HOME/nvim/site/pack/minpac/opt/minpac'))
        if !isdirectory(l:minpac_path)
            echo 'Downloading Minpac'
            call system('git clone https://github.com/k-takata/minpac.git '.l:minpac_path)
        endif
        packadd minpac
        if !exists('*minpac#init')
            echoerr "Minpac doesn't exist! Check download location"
            return
        endif
        call minpac#init({'dir': l:pack_dir})
        call pack#add('k-takata/minpac')
    elseif g:package_manager ==# 'vim-packager'
        if exists('g:packager') | return | endif
        let l:packager_path = get(g:, 'vim_packager_path', expand('$XDG_DATA_HOME/nvim/site/pack/packager/opt/vim-packager'))
        if !isdirectory(l:packager_path)
            echo 'Downloading vim-packager'
            call system('git clone https://github.com/kristijanhusak/vim-packager '.l:packager_path)
        endif
        packadd vim-packager
        if !exists('*packager#init')
            echoerr "vim-packager doesn't exist! Check download location"
            return
        endif
        call packager#init({'dir': l:pack_dir.'/pack/packager', 'jobs': 0})
        call pack#add('kristijanhusak/vim-packager')
    else
        echoerr 'Unrecognized package manager: '.g:package_manager
    endif
endfunction

function! s:pack_add_all() abort "{{{1
    if !exists('g:packlist')
        echoerr "Variable g:packlist doesn't exist! Aborting."
        return
    endif
    for [l:repo, l:opts] in items(g:packlist)
        if g:package_manager ==# 'minpac'
            call minpac#add(l:repo, l:opts)
        elseif g:package_manager ==# 'vim-packager'
            call packager#add(l:repo, l:opts)
        endif
    endfor
endfunction

function! s:pack_update(...) abort "{{{1
    if g:package_manager ==# 'minpac'
        return minpac#update('', {'do': 'call minpac#status()'})
    elseif g:package_manager ==# 'vim-packager'
        return call('packager#update', a:000)
    endif
endfunction

function! pack#add(repo, ...) abort "{{{1
    let l:opts = extend(copy(get(a:000, 0, {})),
        \ {'type': 'opt'}, 'keep')
    let l:name = substitute(a:repo, '^.*/', '', '')
    " Allow simple `if` (e.g., machine-specific) conditions to adding the plugin
    " Note: only evaluated during PackUpdate
    if has_key(l:opts, 'if') && !eval(l:opts.if) | return | endif
    let l:item = {}
    let l:item[a:repo] = l:opts
    let g:packlist = extend(get(g:, 'packlist', {}), l:item)
endfunction

function! pack#install(...) abort "{{{1
    call s:pack_add_all()
    return call('packager#install', a:000)
endfunction

function! pack#update(...) abort "{{{1
    call s:pack_add_all()
    return call('s:pack_update', a:000)
endfunction

function! pack#clean(...) abort "{{{1
    call s:pack_add_all()
    return call('packager#clean', a:000)
endfunction

function! pack#status(...) abort "{{{1
    call s:pack_add_all()
    return call('packager#status', a:000)
endfunction
