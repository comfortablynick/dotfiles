scriptencoding utf-8

" Get usable width of window
" Adapted from https://stackoverflow.com/a/52921337/10370751
function window#width() "{{{1
    let l:width = winwidth(0)
    let l:numberwidth = max([&numberwidth, strlen(line('$')) + 1])
    let l:numwidth = (&number || &relativenumber) ? l:numberwidth : 0
    let l:foldwidth = &foldcolumn
    let l:signwidth = 0

    if &signcolumn ==# 'yes'
        let l:signwidth = 2
    elseif &signcolumn ==# 'auto'
        let l:signs = execute('sign place buffer='.bufnr(''))
        let l:signs = split(l:signs, "\n")
        let l:signwidth = len(l:signs) > 2 ? 2 : 0
    endif
    return l:width - l:numwidth - l:foldwidth - l:signwidth
endfunction

" Create scratch window (accepts mods)
function window#open_scratch(mods, cmd) "{{{1
    if a:cmd ==# ''
        let l:output = ''
    elseif a:cmd[0] == '@'
        if strlen(a:cmd) ==# 2
            let l:output = getreg(a:cmd[1], 1, v:true)
        else
            throw 'Invalid register'
        endif
    elseif a:cmd[0] ==# '!'
        let l:cmd = a:cmd =~' %' ? substitute(a:cmd, ' %', ' ' . expand('%:p'), '') : a:cmd
        let l:output = systemlist(matchstr(l:cmd, '^!\zs.*'))
    else
        let l:output = split(execute(a:cmd), "\n")
    endif

    execute a:mods 'new'
    Scratchify
    call setline(1, l:output)
endfunction

" Close all terminal windows in current tabpage and vim-tmux-runner panes
function window#close_term() "{{{1
    " Kill vtr panes, if any
    " TODO: is there a way to do this only with the pane attached to window?
    silent! VtrKillRunner
    let l:wininfo = filter(getwininfo(), {_,v -> v.tabnr == tabpagenr() && v.terminal == 1})
    if empty(l:wininfo) | return | endif
    for l:win in l:wininfo
        execute l:win.winnr..'quit'
    endfor
endfunction

" Create popup/float terminal
" With help from junegunn/fzf
function window#popterm(cmd) "{{{1
    call s:popup({'width': 0.9, 'height': 0.6})

    if has('nvim')
        call termopen(a:cmd)
    else
        call term_start(a:cmd, #{curwin: 1, hidden: 1, term_finish: 'close'})
    endif
    " Insert mode
    if mode() ==# 'i' | return | endif
    if has('nvim')
        startinsert
    else
        silent! execute 'normal! i'
    endif
endfunction

if has('nvim')
    function s:create_popup(hl, opts) "{{{1 (nvim)
        let l:buf = nvim_create_buf(v:false, v:true)
        let l:opts = extend({'relative': 'editor', 'style': 'minimal'}, a:opts)
        let l:border = has_key(l:opts, 'border') ? remove(l:opts, 'border') : []
        let l:win = nvim_open_win(l:buf, v:true, l:opts)
        call setwinvar(l:win, '&winhighlight', 'NormalFloat:'..a:hl)
        call setwinvar(l:win, '&colorcolumn', '')
        if !empty(l:border)
            call nvim_buf_set_lines(l:buf, 0, -1, v:true, l:border)
        endif
        return l:buf
    endfunction
else
    function s:create_popup(hl, opts) "{{{1 (vim)
        let l:is_frame = has_key(a:opts, 'border')
        let l:buf = l:is_frame ? '' : term_start(&shell, #{hidden: 1, term_finish: 'close'})
        let l:id = popup_create(l:buf, #{
            \ line: a:opts.row,
            \ col: a:opts.col,
            \ minwidth: a:opts.width,
            \ minheight: a:opts.height,
            \ zindex: 50 - l:is_frame,
            \ })

        if l:is_frame
            call setwinvar(l:id, '&wincolor', a:hl)
            call setbufline(winbufnr(l:id), 1, a:opts.border)
            execute 'autocmd BufWipeout * ++once call popup_close('..l:id..')'
        else
            execute 'autocmd BufWipeout * ++once call term_sendkeys('..l:buf..', "exit\<CR>")'
        endif
        return winbufnr(l:id)
    endfunction
endif

function s:popup(opts) "{{{1
    " Support ambiwidth == 'double'
    let l:ambidouble = &ambiwidth ==# 'double' ? 2 : 1

    " Size and position
    let l:width = min([max([0, float2nr(&columns * a:opts.width)]), &columns])
    let l:width += l:width % l:ambidouble
    let l:height = min([max([0, float2nr(&lines * a:opts.height)]), &lines - has('nvim')])
    let l:row = float2nr(get(a:opts, 'yoffset', 0.5) * (&lines - l:height))
    let l:col = float2nr(get(a:opts, 'xoffset', 0.5) * (&columns - l:width))

    " Managing the differences
    let l:row = min([max([0, l:row]), &lines - has('nvim') - l:height])
    let l:col = min([max([0, l:col]), &columns - l:width])
    let l:row += !has('nvim')
    let l:col += !has('nvim')

    " Border style
    let l:style = tolower(get(a:opts, 'border', 'rounded'))
    if !has_key(a:opts, 'border') && !get(a:opts, 'rounded', 1)
        let l:style = 'sharp'
    endif

    if l:style =~# 'vertical\|left\|right'
        let l:mid = l:style ==# 'vertical' ? '│' .. repeat(' ', l:width - 2 * l:ambidouble) .. '│' :
            \ l:style ==# 'left'     ? '│' .. repeat(' ', l:width - 1 * l:ambidouble)
            \                     :        repeat(' ', l:width - 1 * l:ambidouble) .. '│'
        let l:border = repeat([l:mid], l:height)
        let l:shift = { 'row': 0, 'col': l:style ==# 'right' ? 0 : 2, 'width': l:style ==# 'vertical' ? -4 : -2, 'height': 0 }
    elseif l:style =~# 'horizontal\|top\|bottom'
        let l:hor = repeat('─', l:width / l:ambidouble)
        let l:mid = repeat(' ', l:width)
        let l:border = l:style ==# 'horizontal' ? [l:hor] + repeat([l:mid], l:height - 2) + [l:hor] :
            \ l:style ==# 'top' ? [l:hor] + repeat([l:mid], l:height - 1)
            \                       :       repeat([l:mid], l:height - 1) + [l:hor]
        let l:shift = { 'row': l:style ==# 'bottom' ? 0 : 1, 'col': 0, 'width': 0, 'height': l:style ==# 'horizontal' ? -2 : -1 }
    else
        let l:edges = l:style ==# 'sharp' ? ['┌', '┐', '└', '┘'] : ['╭', '╮', '╰', '╯']
        let l:bar = repeat('─', l:width / l:ambidouble - 2)
        let l:top = l:edges[0] .. l:bar .. l:edges[1]
        let l:mid = '│' .. repeat(' ', l:width - 2 * l:ambidouble) .. '│'
        let l:bot = l:edges[2] .. l:bar .. l:edges[3]
        let l:border = [l:top] + repeat([l:mid], l:height - 2) + [l:bot]
        let l:shift = { 'row': 1, 'col': 2, 'width': -4, 'height': -2 }
    endif

    let l:highlight = get(a:opts, 'highlight', 'Comment')
    let l:frame = s:create_popup(l:highlight, {
        \ 'row': l:row, 'col': l:col, 'width': l:width, 'height': l:height, 'border': l:border
        \ })
    let l:term = s:create_popup('Normal', {
        \ 'row': l:row + l:shift.row, 'col': l:col + l:shift.col, 'width': l:width + l:shift.width, 'height': l:height + l:shift.height
        \ })
    if has('nvim')
        execute 'autocmd BufWipeout <buffer> bwipeout' l:frame
        execute 'autocmd TermClose <buffer> call nvim_win_close('.bufwinid(l:frame).', v:true) | bwipeout!' l:term
    endif
endfunction

function window#tab_mod(cmd, ft) " Show cmd in new or existing tab {{{1
    " Reuse open tab if filetype matches `ft`
    " Adapted from https://github.com/airblade/vim-helptab
    let l:cmdtabnr = 0
    for l:i in range(tabpagenr('$'))
        let l:tabnr = l:i + 1
        for l:bufnr in tabpagebuflist(l:tabnr)
            if getbufvar(l:bufnr, '&ft') ==# a:ft
                let l:cmdtabnr = l:tabnr
                break
            endif
        endfor
    endfor
    if l:cmdtabnr
        if tabpagenr() == l:cmdtabnr
            return a:cmd
        else
            return 'tabnext '.l:cmdtabnr.' | '.a:cmd
        endif
    else
        return 'tab '.a:cmd
    endif
endfunction

" Vim Only
if !has('nvim')
    function window#float_term(cmd, width, height) " Simple vim-only popup terminal {{{1
        let l:width = float1nr(&columns * a:width)
        let l:height = float2nr(&lines * a:height)
        let l:bufnr = term_start(a:cmd, {'hidden': 1, 'term_finish': 'close', 'cwd': getcwd()})
        let l:border_highlight = 'Todo'

        let l:winid = popup_create(l:bufnr, {
            \ 'minwidth': l:width,
            \ 'maxwidth': l:width,
            \ 'minheight': l:height,
            \ 'maxheight': l:height,
            \ 'border': [],
            \ 'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
            \ 'borderhighlight': [l:border_highlight],
            \ 'padding': [0,1,0,1],
            \ 'highlight': l:border_highlight
            \ })

        " Optionally set the 'Normal' color for the terminal buffer
        " call setwinvar(winid, '&wincolor', 'Special')

        return l:winid
    endfunction
endif

" Vim-tmux-resize {{{1
" Simplified version of github.com/RyanMillerC/better-vim-tmux-resizer
" Maps <M-h/j/k/l> to resize vim splits in the given direction.
" If the movement operation has no effect in Vim, it forwards the operation to
" Tmux.
let g:tmux_resizer_resize_count = get(g:, 'tmux_resizer_resize_count', 5)
let g:tmux_resizer_vertical_resize_count = get(g:, 'tmux_resizer_vertical_resize_count', 10)

function s:VimResize(direction) "{{{2
  " Prevent resizing Vim upward when there is only a single window
  if a:direction ==# 'j' && winnr('$') <= 1
    return
  endif

  " Prevent resizing Vim upward when down is pressed with all vsplit windows
  if a:direction ==# 'k'
    let l:all_windows_are_vsplit = 1
    for l:window in range(1, winnr('$'))
      if win_screenpos(l:window)[0] != 1
        let l:all_windows_are_vsplit = 0
      endif
    endfor
    if l:all_windows_are_vsplit
      return
    endif
  endif

  " Resize Vim window toward given direction, like tmux
  let l:current_window_is_last_window = winnr() == winnr('$')
  if a:direction ==# 'h' || a:direction ==# 'k'
    let l:modifier = l:current_window_is_last_window ? '+' : '-'
  else
    let l:modifier = l:current_window_is_last_window ? '-' : '+'
  endif

  if a:direction ==# 'h' || a:direction ==# 'l'
    let l:command = 'vertical resize'
    let l:window_resize_count = g:tmux_resizer_vertical_resize_count
  else
    let l:command = 'resize'
    let l:window_resize_count = g:tmux_resizer_resize_count
  endif

  execute l:command l:modifier..l:window_resize_count
endfunction

function window#tmux_aware_resize(direction) "{{{2
  let l:previous_window_width = winwidth(0)
  let l:previous_window_height = winheight(0)

  " Attempt to resize Vim window
  call s:VimResize(a:direction)

  let l:tmux = split($TMUX, ',')
  " Call tmux if in session and vim window dimentions did not change
  if l:previous_window_height == winheight(0) && l:previous_window_width == winwidth(0) && len(l:tmux)
    if a:direction ==# 'h' || a:direction ==# 'l'
      let l:resize_count = g:tmux_resizer_vertical_resize_count
    else
      let l:resize_count = g:tmux_resizer_resize_count
    endif
    let l:args = 'resize-pane -'..tr(a:direction, 'hjkl', 'LDUR')..' '..l:resize_count
    let l:tmux_socket = split($TMUX, ',')[0]
    let l:tmux_cmd = printf('tmux -S %s %s', l:tmux_socket, l:args)
    call system(l:tmux_cmd)
  endif
endfunction
