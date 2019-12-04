" ====================================================
" Filename:    autoload/pack.vim
" Description: Handle packages and interface with package manager
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2019-12-04
" ====================================================

" TODO: set minpac#init path as arg to pack#init
function! pack#init() abort
    " Make Pack command available before packages are added
    command! -nargs=+ Pack call pack#add(<args>)
endfunction

" Minpac wrapper functions
function! s:minpac_init() abort
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
    if has('nvim')
        call minpac#init({'dir': expand('$XDG_DATA_HOME/nvim/site')})
    else
        call minpac#init({'dir': expand('$HOME/.vim')})
    endif
endfunction

function! s:minpac_add_all() abort
    if !exists('g:packlist')
        echoerr "Variable g:packlist doesn't exist! Aborting."
        return
    endif
    for [repo, opts] in items(g:packlist)
        call minpac#add(repo, opts)
    endfor
endfunction

function! pack#add(repo, ...) abort
    call s:minpac_init()
    let l:opts = extend(copy(get(a:000, 0, {})),
        \ { 'type': 'opt'}, 'keep')
    " Allow simple `if` conditions to adding the plugin
    " Note: only evaluated during PackUpdate
    if has_key(l:opts, 'if')
        if !eval(l:opts.if) | return | endif
    endif
    if has_key(l:opts, 'for')
        let l:name = substitute(a:repo, '^.*/', '', '')
        let l:ft = type(l:opts.for) == type([]) ? join(l:opts.for, ',') : l:opts.for
        execute printf('autocmd FileType %s packadd %s', l:ft, l:name)
    else
    let l:item = {}
    let l:item[a:repo] = l:opts
    let g:packlist = extend(get(g:, 'packlist', {}), l:item)
    end
endfunction

function! pack#update() abort
    call s:minpac_init()
    call s:minpac_add_all()
    " Load remote plugins
    let g:deoplete#enable_at_startup = 0
    packadd! deoplete.nvim
    return minpac#update('', {'do': 'call minpac#status()'})
endfunction

function! pack#clean(...) abort
    call s:minpac_init()
    call s:minpac_add_all()
    return call('minpac#clean', a:000)
endfunction

function! pack#status(...) abort
    call s:minpac_init()
    call s:minpac_add_all()
    return call('minpac#status', a:000)
endfunction
