" Execute line/selection
nnoremap <silent><buffer> yxx     :execute trim(getline('.'))<CR>
vnoremap <silent><buffer> <Enter> "xy:@x<CR>
" Close on 'q'
nnoremap <silent><buffer> q :call buffer#quick_close()<CR>
" Help TOC
nnoremap <silent><buffer> <Leader>t :call <SID>show_toc()<CR>
nnoremap <silent><buffer> gO :call <SID>show_toc()<CR>

" loclist TOC for vim
function s:show_toc()
    let l:bufname = bufname('%')
    let l:info = getloclist(0, {'winid': 1})
    if !empty(l:info) && getwinvar(l:info.winid, 'qf_toc') ==# l:bufname
        lopen
        return
    endif

    let l:toc = []
    let l:lnum = 2
    let l:last_line = line('$') - 1
    let l:last_added = 0
    let l:has_section = 0
    let l:has_sub_section = 0

    while l:lnum && l:lnum <= l:last_line
        let l:level = 0
        let l:add_text = ''
        let l:text = getline(l:lnum)

        if l:text =~# '^=\+$' && l:lnum + 1 < l:last_line
            " A de-facto section heading.  Other headings are inferred.
            let l:has_section = 1
            let l:has_sub_section = 0
            let l:lnum = nextnonblank(l:lnum + 1)
            let l:text = getline(l:lnum)
            let l:add_text = l:text
            while l:add_text =~# '\*[^*]\+\*\s*$'
                let l:add_text = matchstr(l:add_text, '.*\ze\*[^*]\+\*\s*$')
            endwhile
        elseif l:text =~# '^[A-Z0-9][-A-ZA-Z0-9 .][-A-Z0-9 .():]*\%([ \t]\+\*.\+\*\)\?$'
            " Any line that's yelling is important.
            let l:has_sub_section = 1
            let l:level = l:has_section
            let l:add_text = matchstr(l:text, '.\{-}\ze\s*\%([ \t]\+\*.\+\*\)\?$')
        elseif l:text =~# '\~$'
            \ && matchstr(l:text, '^\s*\zs.\{-}\ze\s*\~$') !~# '\t\|\s\{2,}'
            \ && getline(l:lnum - 1) =~# '^\s*<\?$\|^\s*\*.*\*$'
            \ && getline(l:lnum + 1) =~# '^\s*>\?$\|^\s*\*.*\*$'
            " These lines could be headers or code examples.  We only want the
            " ones that have subsequent lines at the same indent or more.
            let l:l = nextnonblank(l:lnum + 1)
            if getline(l:l) =~# '\*[^*]\+\*$'
                " Ignore tag lines
                let l:l = nextnonblank(l:l + 1)
            endif

            if indent(l:lnum) <= indent(l:l)
                let l:level = l:has_section + l:has_sub_section
                let l:add_text = matchstr(l:text, '\S.*')
            endif
        endif

        let l:add_text = substitute(l:add_text, '\s\+$', '', 'g')
        if !empty(l:add_text) && l:last_added != l:lnum
            let l:last_added = l:lnum
            call add(l:toc, {'bufnr': bufnr('%'), 'lnum': l:lnum,
                \ 'text': repeat('  ', l:level) . l:add_text})
        endif
        let l:lnum = nextnonblank(l:lnum + 1)
    endwhile

    call setloclist(0, l:toc, ' ')
    call setloclist(0, [], 'a', {'title': 'Help TOC'})
    lopen
    let w:qf_toc = l:bufname
endfunction
