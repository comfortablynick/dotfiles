let b:localrc_loaded = 0
let b:localrc_files = []

function localrc#load_from_env()
    " Use direnv to find .lvimrc files and add to env var $LOCAL_VIMRC
    " See https://github.com/direnv/direnv/wiki/Vim
    let l:lvimrcs = $LOCAL_VIMRC
    if empty(l:lvimrcs) || get(b:, 'localrc_loaded', 0)
        return
    endif
    " call localrc#load(l:lvimrcs)
    for l:file in split(l:lvimrcs, ':')
        if index(b:localrc_files, l:file) == -1
            source `=l:file`
            let b:localrc_loaded += 1
            let b:localrc_files += [l:file]
        endif
    endfor
endfunction
