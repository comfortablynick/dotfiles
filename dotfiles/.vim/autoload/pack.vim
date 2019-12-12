" ====================================================
" Filename:    autoload/pack.vim
" Description: Handle packages and interface with package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-05
" ====================================================

function! pack#init() abort
    " Make Pack command available before packages are added
    command! -nargs=+ Pack call pack#add(<args>)
endfunction

" Package manager wrapper functions
function! s:pack_init() abort
    let l:pack_dir = expand(has('nvim') ? '$XDG_DATA_HOME/nvim/site' : '$HOME/.vim')
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
        let l:packager_path = get(g:, 'vim_packager_path', expand('$XDG_DATA_HOME/nvim/site/pack/minpac/opt/vim-packager'))
        if !isdirectory(l:packager_path)
            echo 'Downloading vim-packager'
            call system('git clone https://github.com/kristijanhusak/vim-packager '.l:packager_path)
        endif
        packadd vim-packager
        if !exists('*packager#init')
            echoerr "vim-packager doesn't exist! Check download location"
            return
        endif
        call packager#init({'dir': l:pack_dir.'/pack/minpac'})
        call pack#add('kristijanhusak/vim-packager')
    else
        echoerr 'Unrecognized package manager: '.g:package_manager
    endif
endfunction

function! s:pack_add_all() abort
    if !exists('g:packlist')
        echoerr "Variable g:packlist doesn't exist! Aborting."
        return
    endif
    for [repo, opts] in items(g:packlist)
        if g:package_manager ==# 'minpac'
            call minpac#add(repo, opts)
        elseif g:package_manager ==# 'vim-packager'
            call packager#add(repo, opts)
        endif
    endfor
endfunction

function! s:pack_update(...) abort
    if g:package_manager ==# 'minpac'
        return minpac#update('', {'do': 'call minpac#status()'})
    elseif g:package_manager ==# 'vim-packager'
        return call('packager#update', a:000)
    endif
endfunction

function! pack#add(repo, ...) abort
    call s:pack_init()
    let l:opts = extend(copy(get(a:000, 0, {})),
        \ {'type': 'opt'}, 'keep')
    let l:name = substitute(a:repo, '^.*/', '', '')
    " Allow simple `if` conditions to adding the plugin
    " Note: only evaluated during PackUpdate
    if has_key(l:opts, 'if') && !eval(l:opts.if) | return | endif
    if has_key(l:opts, 'rplugin') && eval(l:opts.rplugin)
        let g:packlist_rplugins = add(get(g:, 'packlist_rplugins', []), l:name)
    endif
    if has_key(l:opts, 'for')
        let l:ft = type(l:opts.for) == type([]) ? join(l:opts.for, ',') : l:opts.for
        execute printf('autocmd FileType %s packadd %s', l:ft, l:name)
    else
    let l:item = {}
    let l:item[a:repo] = l:opts
    let g:packlist = extend(get(g:, 'packlist', {}), l:item)
    end
endfunction

function! pack#update(...) abort
    call s:pack_init()
    call s:pack_add_all()
    call s:pack_update(a:000)
    if exists('g:packlist_rplugins')
        for item in g:packlist_rplugins
            execute 'packadd! '.item
        endfor
        UpdateRemotePlugins
    endif
endfunction

function! pack#clean(...) abort
    call s:pack_init()
    call s:pack_add_all()
    return call('packager#clean', a:000)
endfunction

function! pack#status(...) abort
    call s:pack_init()
    call s:pack_add_all()
    return call('packager#status', a:000)
endfunction
