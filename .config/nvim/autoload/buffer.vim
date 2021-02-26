function buffer#load_lvimrc() " Load local vimrc using env var of paths {{{1
    " Use direnv to find .lvimrc files and add to env var $LOCAL_VIMRC
    " See https://github.com/direnv/direnv/wiki/Vim
    let b:localrc_files  = get(b:, 'localrc_files', [])
    let b:localrc_loaded = get(b:, 'localrc_loaded', 0)
    let l:lvimrcs = $LOCAL_VIMRC
    if empty(l:lvimrcs) | return | endif
    for l:file in split(l:lvimrcs, ':')
        if index(b:localrc_files, l:file) == -1
            source `=l:file`
            let b:localrc_loaded += 1
            let b:localrc_files  += [l:file]
        endif
    endfor
endfunction

function buffer#restore_cursor_after(motion) " Restore cursor after motion {{{1
    let l:wv = winsaveview()
    execute 'normal! '.a:motion
    call winrestview(l:wv)
endfunction

function buffer#close_complete(...)
    return ['other', 'hidden', 'unnamed', 'all', 'this', 'select']
endfunction

function buffer#close(bang, option) "{{{1
    let l:option = trim(a:option)
    let l:command = printf('bwipeout%s', a:bang ? '!' : '')
    if l:option ==# 'select'
        pwd
        ls!
        call feedkeys(':'..l:command ..' ', 'n')
    elseif l:option ==# 'this'
        execute l:command
    else
        let l:all_bufs = getbufinfo()
        if l:option ==# 'other'
            let l:filtered_bufinfo = filter(l:all_bufs, {_,v -> v.bufnr != bufnr('%')})
        elseif l:option ==# 'hidden'
            let l:filtered_bufinfo = filter(l:all_bufs, {_,v -> empty(v.windows)})
        elseif l:option ==# 'nameless'
            let l:filtered_bufinfo = filter(l:all_bufs, {_,v -> v.name ==# ''})
        elseif l:option ==# 'all'
            let l:filtered_bufinfo = l:all_bufs
        else
            echohl WarningMsg 
            echo printf('buffer close: invalid option ''%s''', l:option) 
            echohl None
            return
        endif

        let l:buffer_numbers = map(l:filtered_bufinfo, {_,v -> v.bufnr})
        if !empty(l:buffer_numbers)
            execute printf('%s %s', l:command, join(l:buffer_numbers, ' '))
        endif
    endif
endfunction

" Close all buffers that can be closed, other than current
function buffer#only(...) " Close buffers other than current (or supplied bufnr) {{{1
    " Argument should be dict with following keys
    "   bufnr   buffer other than current to be left open
    "   bang    force close buffers even if modified
    let l:opts      = get(a:, 1, {})
    let l:cur_bufnr = get(l:opts, 'bufnr', bufnr('%'))
    let l:force     = get(l:opts, 'bang', 0)

    let l:buffers = filter(
        \ getbufinfo({'bufloaded': 1}),
        \ {_,v -> !v.hidden && v.bufnr != l:cur_bufnr}
        \)
    let l:deleted = 0
    let l:modified = 0
    for l:buf in l:buffers
        let l:bn = l:buf.bufnr
        if !l:force && l:buf.changed
            let l:modified += 1
        else
            silent exe printf(
                \ 'bdelete%s %d', 
                \ l:force || has_key(l:buf.variables, 'term_title') ? '!' : '',
                \ l:bn,
                \)
            let l:deleted += 1
        endif
    endfor
    let l:msg = 'BufOnly:'
    if l:deleted || l:modified
        if l:deleted
            let l:msg ..= printf(' %d buffer%s deleted%s',
                \ l:deleted,
                \ l:deleted == 1 ? '' : 's',
                \ l:modified ? ';' : '',
                \)
        endif
        if l:modified
            let l:msg ..= printf(
                \ ' %d buffer%s modified',
                \ l:modified,
                \ l:modified == 1 ? '' : 's',
                \)
        endif
    else
        let l:msg ..= ' no buffers to delete!'
    endif
    echom l:msg
endfunction

function buffer#autoclose() " Close unnecessary buffers (use with QuitPre autocmd) {{{1
    let l:cur_bufnr = bufnr('%')
    let l:buffers = filter(
        \ getbufinfo(#{bufloaded: 1, buflisted: 1}),
        \ {_,v -> v.bufnr != l:cur_bufnr}
        \)
    if empty(filter(copy(l:buffers), {_,v -> !v.hidden}))
        return buffer#only()
    endif
endfunction

" Close buffer if not modifiable; quit vim if last buf
" ex: map to `q` on buffers where macros wouldn't be used
function buffer#quick_close() " Close non-modifiable buffers or quit if last buffer {{{1
    if &l:modifiable
        echohl WarningMsg | echo 'autoclose: cannot quick close modifiable buffer' | echohl None
        return
    endif
    if len(getbufinfo(#{buflisted: 1})) < 2 | quit | endif
    bwipeout!
endfunction

let s:prototype = {}

" Sayonara :: close buffer without necessarily disrupting window layout {{{1
" Adapted from https://github.com/mhinz/vim-sayonara
" s:prototype.create_scratch_buffer() {{{2
function s:prototype.create_scratch_buffer()
    enew!
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    return bufnr('%')
endfunction

" s:prototype.handle_modified_buffer() {{{2
function s:prototype.handle_modified_buffer()
    if &l:modified
        echo 'Unsaved changes: [w]rite, [s]kip, [b]reak '
        let l:choice = nr2char(getchar())
        if l:choice ==? 'w'
            try
                write
            catch /E32/
                redraw | echohl ErrorMsg | echomsg 'No file name.' | echohl NONE
                return 'return'
            endtry
        elseif l:choice ==? 's'
            return ''
        else
            redraw!
            return 'return'
        endif
    endif
    return ''
endfunction

" s:prototype.handle_quit() {{{2
function s:prototype.handle_quit()
    execute 'silent bdelete!' l:self.target_buffer
    redraw!
    if get(g:, 'sayonara_confirm_quit')
        echo 'No active buffer remaining. Quit Vim? [y/n]: '
        if nr2char(getchar()) !=? 'y'
            redraw!
            return 'return'
        endif
    endif
    return 'quit!'
endfunction

" s:prototype.handle_window() {{{2
function s:prototype.handle_window()
    if has_key(get(g:, 'sayonara_filetypes', {}), &filetype)
        execute g:sayonara_filetypes[&filetype]
        return
    endif

    " quickfix, location or q:
    if &l:buftype ==# 'quickfix' || (&l:buftype ==# 'nofile' && &l:filetype ==# 'vim')
        try
            close
            return
        catch /E444/  " cannot close last window
        endtry
    endif

    " Although q: sets &ft == 'vim', q/ and q? do not.
    try
        lclose
    catch /E11/  " invalid in command-line window
        close
        let l:ret = 1
    catch /E444/  " cannot close last window
        execute l:self.handle_quit()
    endtry
    if exists('ret')
        unlet l:ret
        return
    endif

    " :Sayonara!

    let l:do_delete = !l:self.is_buffer_shown_in_another_window(l:self.target_buffer)

    if l:self.do_preserve
        let l:scratch_buffer = l:self.preserve_window()
        if l:do_delete
            " After preserve_window(), the target buffer might not exist
            " anymore (bufhidden=delete).
            if bufloaded(l:self.target_buffer)
                \ && (l:scratch_buffer != l:self.target_buffer)
                execute 'silent bdelete!' l:self.target_buffer
            endif
        endif
        return
    endif

    ":Sayonara

    let l:valid_buffers = len(filter(range(1, bufnr('$')),
        \ {_, v -> buflisted(v) && v != l:self.target_buffer}))

    " Special case: don't quit last window if there are other listed buffers
    if tabpagenr('$') == 1 && winnr('$') == 1 && l:valid_buffers >= 1
        execute 'silent bdelete!' l:self.target_buffer
        return
    endif

    try
        close!
    catch /E444/  " cannot close last window
        execute l:self.handle_quit()
    endtry

    if l:do_delete
        if bufloaded(l:self.target_buffer)
            execute 'silent bdelete!' l:self.target_buffer
        endif
    endif
endfunction

" s:prototype.preserve_window() {{{2
function s:prototype.preserve_window()
    let l:altbufnr = bufnr('#')
    let l:valid_buffers = filter(range(1, bufnr('$')),
        \ {_,v -> buflisted(v) && v != l:self.target_buffer})

    if empty(l:valid_buffers)
        return l:self.create_scratch_buffer()
    elseif index(l:valid_buffers, l:altbufnr) == -1
        " get previous valid buffer
        let l:bufs = []
        for l:buf in l:valid_buffers
            if l:buf < l:self.target_buffer
                call insert(l:bufs, l:buf, 0)
            else
                call add(l:bufs, l:buf)
            endif
        endfor
        execute 'buffer!' l:bufs[0]
    else
        buffer! #
    endif
endfunction

" s:prototype.is_buffer_shown_in_another_window() {{{2
function s:prototype.is_buffer_shown_in_another_window(target_buffer)
    let l:current_tab = tabpagenr()
    let l:other_tabs  = filter(range(1, tabpagenr('$')), {_,v -> v != l:current_tab})

    if len(filter(tabpagebuflist(l:current_tab), {_,v -> v == a:target_buffer})) > 1
        return 1
    endif

    for l:tab in l:other_tabs
        if index(tabpagebuflist(l:tab), a:target_buffer) != -1
            return 1
        endif
    endfor

    return 0
endfunction

" buffer#sayonara() {{{1
function buffer#sayonara(do_not_preserve)
    let l:hidden = &hidden
    set hidden
    try
        let l:instance = extend(s:prototype, {
            \ 'do_preserve': !a:do_not_preserve,
            \ 'target_buffer': bufnr('%'),
            \ })
        execute l:instance.handle_modified_buffer()
        call l:instance.handle_window()
    finally
        let &hidden = l:hidden
    endtry
endfunction
