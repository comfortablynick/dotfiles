" Acknowledgments: Code from thinca <thinca+vim@gmail.com> (zlib License)
let b:localrc_loaded = 0
let b:localrc_files = []

function localrc#load_from_env()
    if !empty('$LOCAL_VIMRC') && get(b:, 'localrc_loaded', 0) == 0
        call localrc#load('$LOCAL_VIMRC')
    endif
endfunction

function localrc#load(fnames, ...)
    for l:file in localrc#search(a:fnames,
        \ 1 <= a:0 ? a:1 : expand('%:p:h'),
        \ 2 <= a:0 ? a:2 : -1)
        if index(b:localrc_files, l:file) < 0
            source `=file`
            let b:localrc_loaded += 1
            let b:localrc_files += [l:file]
        endif
    endfor
endfunction

function localrc#search(fnames, ...)
    let l:path = 1 <= a:0 ? a:1 : expand('%:p:h')
    if empty(a:fnames) || !isdirectory(l:path)
        return []
    endif

    let l:depth = 2 <= a:0 ? a:2 : -1
    let l:targets = []
    let l:dir = fnamemodify(l:path, ':p:h')
    let l:updir = ''
    while l:depth != 0 && l:dir !=# l:updir
        let l:targets = s:match_files(l:dir, a:fnames) + l:targets
        let l:updir = l:dir
        let l:dir = fnamemodify(l:dir, ':h')
        if (has('win32') || has('win64')) && l:dir =~? '^\\\\[^\\]\+$'
            break
        endif
        let l:depth -= 1
    endwhile
    return l:targets
endfunction

function s:match_files(path, fname)
    if type(a:fname) == type([])
        let l:files = []
        for l:f in a:fname
            let l:files += s:match_files(a:path, l:f)
        endfor
        return s:uniq(l:files)
    endif

    let l:path = escape(a:path, '*?[,')
    if a:fname[0] ==# '/'
        let l:files = split(globpath(l:path, '/.*', 1), "\n")
            \         + split(globpath(l:path, '/*' , 1), "\n")
        let l:pat = a:fname[1:]
        call filter(map(l:files, {_,v -> fnamemodify(v, ':t')}), {_,v -> v =~# l:pat})

    else
        let l:files = map(split(globpath(l:path, a:fname, 1), "\n"),
            \               'fnamemodify(v:val, ":t")')
    endif

    return filter(map(l:files, {_,v -> a:path..'/'..v}), {_,v -> filereadable(v)})
endfunction

" - string only.
" - can not treat a empty string.
function s:uniq(list)
    let l:i = 0
    let l:len = len(a:list)
    let l:seen = {}
    while l:i < l:len
        if has_key(l:seen, a:list[l:i])
            call remove(a:list, l:i)
        else
            let l:seen[a:list[l:i]] = 1
            let l:i += 1
        endif
    endwhile
    return a:list
endfunction
