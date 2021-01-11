set conceallevel=2

let g:asciidoctor_syntax_conceal = 1

" Separate sentences in a paragraph and put each on its own line
function FormatExpr(start, end)
    silent execute a:start.','.a:end.'s/[.!?]\zs /\r/g'
endfunction

set formatexpr=FormatExpr(v:lnum,v:lnum+v:count-1)

" TODO: make outline prettier
function s:toc()
    let l:toc = []
    let l:buf = bufnr('')
    let l:lines = filter(map(getbufline(l:buf, 1, '$'), {k,v->[k+1, v]}), {_,v->v[1] =~# '\v^\={2,}'})
    for [l:ln, l:text] in l:lines
        call add(l:toc, #{bufnr: l:buf, lnum: l:ln, text: l:text})
    endfor
    call setloclist(0, l:toc, ' ')
    call setloclist(0, [], 'a', #{title: 'TOC'})
endfunction

nnoremap <buffer> gO <Cmd>call <SID>toc()\|call quickfix#loc_toggle(0)<CR>

setlocal errorformat=asciidoctor:\ %tRROR:\ %f:\ line\ %l:\ %m,asciidoctor:\ %tARNING:\ %f:\ line\ %l:\ %m

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
let b:undo_ftplugin .= '|setl cole< fex< |nunmap <buffer> gO'
