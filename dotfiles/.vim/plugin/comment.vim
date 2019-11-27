" ====================================================
" Filename:    plugin/comment.vim
" Description: Simple comment/uncomment script, inspired by Tim Pope's commentary.vim
" From:        https://gist.github.com/PeterRincker/13bde011c01b7fc188c5
" License:     MIT
" Last Change: 2019-11-24
" ====================================================
if exists('g:loaded_comment_vim_qsyxneop') | finish | endif
let g:loaded_comment_vim_qsyxneop = 1

" Uses b:commentstring or 'commentstring' as the comment pattern
" example:
"    let &commentstring = '/*%s*/'

let g:comment_plugin = 'tcomment'

if get(g:, 'comment_plugin') ==# 'commentary'
    packadd vim-commentary
    xmap <Leader>c          <Plug>Commentary
    nmap <Leader>c          <Plug>Commentary
    omap <Leader>c          <Plug>Commentary
    nmap <Leader>c<Space>   <Plug>CommentaryLine
    nmap <Leader>cu         <Plug>Commentary<Plug>Commentary
    if maparg('c','n') ==# '' && !exists('v:operator')
        nmap c<Leader>c     <Plug>ChangeCommentary
    endif
elseif get(g:, 'comment_plugin') ==# 'tcomment'
    packadd tcomment_vim
    " Add additional mappings for nerdcomment muscle memory
    xmap <silent><Leader>c          <Plug>TComment_gc
    nmap <Leader>c<Space>           <Plug>TComment_gcc
    omap <silent><Leader>c          <Plug>TComment_gc
endif

lua require('comment')
lua TestComment()

" nnoremap gcc :<c-u>.,.+<c-r>=v:count<cr>call <SID>toggle_comment()<cr>
" nnoremap gc :<c-u>set opfunc=<SID>comment_op<cr>g@
" xnoremap gc :call <SID>toggle_comment()<cr>

function! s:comment_op(...)
  '[,']call s:toggle_comment()
endfunction

function! s:toggle_comment() range
  let comment = substitute(get(b:, 'commentstring', &commentstring), '\s*\(%s\)\s*', '%s', '')
  let pattern = '\V' . printf(escape(comment, '\'), '\(\s\{-}\)\s\(\S\.\{-}\)\s\=')
  let replace = '\1\2'
  if getline('.') !~ pattern
    let indent = matchstr(getline('.'), '^\s*')
    let pattern = '^' . indent . '\zs\(\s*\)\(\S.*\)'
    let replace = printf(comment, '\1 \2' . (comment =~? '%s$' ? '' : ' '))
  endif
  for lnum in range(a:firstline, a:lastline)
    call setline(lnum, substitute(getline(lnum), pattern, replace, ''))
  endfor
endfunction
