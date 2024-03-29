" Author: Nick Murphy <comfortablynick@gmail.com>
" Description: Load available asynctasks.vim tasks

let s:task = {}

function! s:task.source()
    if exists('*asynctasks#list') == 0
        Lazy load asynctasks.vim
    endif
    let l:list = asynctasks#list('')
    let l:source = []
    let l:longest_name = max(map(copy(l:list), {_,v->len(v['name'])})) + 2
    for l:item in l:list
        let l:source += [
            \ printf('%-'.l:longest_name.'s %-10s :   %s',
            \ l:item['name'],
            \ '<'.l:item['scope'].'>',
            \ l:item['command'])
            \ ]
    endfor
    return l:source
endfunction

function! s:task.sink(selected)
    let l:name = split(a:selected, '<')[0]
    let l:name = substitute(l:name, '^\s*\(.\{-}\)\s*$', '\1', '')
    if strlen(l:name)
        execute 'AsyncTask' fnameescape(l:name)
    endif
endfunction

let s:task.syntax = 'clap_task'
let g:clap#provider#task# = s:task
