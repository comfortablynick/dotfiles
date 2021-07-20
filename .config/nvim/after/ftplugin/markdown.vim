setlocal tabstop=2
setlocal spell

let g:markdown_fenced_languages = ['lua', 'python', 'sh', 'vim', 'rust']
" function! MarkdownFoldLevel()
"     " WIP: only increases fold level, never decreases
"     let l:currline = getline(v:lnum)
"     if l:currline =~# '^## .*$'     | return '>1' | endif
"     if l:currline =~# '^### .*$'    | return '>2' | endif
"     if l:currline =~# '^#### .*$'   | return '>3' | endif
"     if l:currline =~# '^##### .*$'  | return '>4' | endif
"     if l:currline =~# '^###### .*$' | return '>5' | endif
"     return '='
" endfunction
"
" setlocal foldexpr=MarkdownFoldLevel()
" setlocal foldmethod=expr
" setlocal foldlevel=1

function s:indent(indent)
    let l:col = virtcol('.')
    if a:indent
        execute 'normal! >>' (l:col + shiftwidth())..'|'
    else
        execute 'normal! <<' (l:col - shiftwidth())..'|'
    endif
endfunction

function s:is_empty_list_item()
    return getline('.') =~# '\v^\s*%([-*+]|\d\.)\s*$'
endfunction

function s:is_empty_quote()
    return getline('.') =~# '\v^\s*(\s?\>)+\s*$'
endfunction

if has('nvim-0.5') && executable('glow')
    command -buffer Preview lua
        \ require'window'.float_term(
        \ 'glow '..vim.fn.expand('%', ':p'),
        \ 0.4,
        \ true,
        \ vim.fn.expand('%', ':.')
        \ )
    nnoremap <buffer> gp <Cmd>Preview<CR>
endif

inoremap <buffer> <C-]> <Cmd>call <SID>indent(1)<CR>
inoremap <buffer> <C-[> <Cmd>call <SID>indent(0)<CR>
imap <buffer><expr> <Tab>   <SID>is_empty_list_item() ? "<Cmd>call <SID>indent(1)<CR>" : v:lua.smart_tab()
imap <buffer><S-Tab> <Plug>(completion_smart_s_tab)
" imap <buffer><expr> <S-Tab> "<Cmd>call <SID>indent(0)<CR>"

function s:jump_to_heading(direction, count)
    let l:col = virtcol('.')
    execute a:direction ==# 'up' ? '?^#' : '/^#'
    if a:count > 1
        execute 'normal!' repeat('n', a:direction ==# 'up' && l:col != 1 ? a:count : a:count - 1)
    endif
    execute 'normal!' l:col..'|'
endfunction

nnoremap <buffer> ]] <Cmd>call <SID>jump_to_heading("down", v:count1)<CR>
nnoremap <buffer> [[ <Cmd>call <SID>jump_to_heading("up", v:count1)<CR>

let s:highlight_headings = v:false

if s:highlight_headings
    let s:md_sign_ns = 'md_headlines'

    call sign_define('headline1',  {'linehl': 'markdownH1Line'})
    call sign_define('headline2',  {'linehl': 'markdownH2Line'})
    call sign_define('headline3',  {'linehl': 'markdownH3Line'})

    function s:set_signs()
        let l:buf = bufnr()
        let l:offset = max([line('w0') - 1, 0])
        let l:lines = getbufline(l:buf, line('w0'), line('w$'))

        call sign_unplace(s:md_sign_ns, #{buffer: bufname(l:buf)})

        for l:i in range(len(l:lines))
            let l:line = l:lines[l:i]
            let l:level = strlen(matchstr(l:line, '^#\+'))
            if l:level > 0
                call sign_place(0, s:md_sign_ns, 'headline'..l:level, l:buf, #{lnum: l:i + 1 + l:offset})
            endif
        endfor
    endfunction

    let s:sign_events = 'FileChangedShellPost,Syntax,TextChanged,InsertLeave'
    if has('nvim')
        let s:sign_events ..= ',WinScrolled'
    endif

    execute 'autocmd' s:sign_events '<buffer> call s:set_signs()'
endif

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
" TODO: sign unplace doesn't seem to work here
let b:undo_ftplugin ..= '|setl ts< spell<'
    \ ..'|sil! iunmap <buffer> <Tab>|sil! iunmap <buffer> <S-Tab>'
    \ ..'|sil! iunmap <buffer> <C-]>|sil! iunmap <buffer> <C-[>'
    \ ..'|sil! nunmap <buffer> ]]   |sil! nunmap <buffer> [['

if s:highlight_headings
    let b:undo_ftplugin ..= '|sign unplace * group='..s:md_sign_ns..' buffer='..bufnr()
endif
