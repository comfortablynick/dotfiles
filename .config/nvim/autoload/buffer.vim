" Restore cursor position after motion
function buffer#restore_cursor_after(motion)
    let l:wv = winsaveview()
    execute 'normal! '.a:motion
    call winrestview(l:wv)
endfunction

" Close buffer if not modifiable; quit vim if last buf
" ex: map to `q` on buffers where macros wouldn't be used
function buffer#quick_close()
    if &l:modifiable
        echohl WarningMsg | echo 'Cannot quick close modifiable buffer' | echohl None
        return
    endif
    if bufnr('$') == 1
        quit
    else
        bwipeout
    endif
endfunction

let s:prototype = {}

" Sayonara :: close buffer without necessarily disrupting window layout
" Adapted from https://github.com/mhinz/vim-sayonara
" s:prototype.create_scratch_buffer() {{{1
function s:prototype.create_scratch_buffer()
    enew!
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    return bufnr('%')
endfunction

" s:prototype.handle_modified_buffer() {{{1
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

" s:prototype.handle_quit() {{{1
function s:prototype.handle_quit()
    execute 'silent bdelete!' l:self.target_buffer
    redraw!
    if (get(g:, 'sayonara_confirm_quit'))
        echo 'No active buffer remaining. Quit Vim? [y/n]: '
        if nr2char(getchar()) !=? 'y'
            redraw!
            return 'return'
        endif
    endif
    return 'quit!'
endfunction

" s:prototype.handle_window() {{{1
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
    if (tabpagenr('$') == 1) && (winnr('$') == 1) && (l:valid_buffers >= 1)
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

" s:prototype.preserve_window() {{{1
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

" s:prototype.is_buffer_shown_in_another_window() {{{1
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
function buffer#sayonara(do_preserve)
    let l:hidden = &hidden
    set hidden
    try
        let l:instance = extend(s:prototype, {
            \ 'do_preserve': a:do_preserve,
            \ 'target_buffer': bufnr('%'),
            \ })
        execute l:instance.handle_modified_buffer()
        call l:instance.handle_window()
    finally
        let &hidden = l:hidden
    endtry
endfunction
