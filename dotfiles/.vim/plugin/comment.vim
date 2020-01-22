" ====================================================
" Filename:    plugin/comment.vim
" Description: Simple comment/uncomment script, inspired by Tim Pope's commentary.vim
" From:        https://gist.github.com/PeterRincker/13bde011c01b7fc188c5
" License:     MIT
" Last Change: 2020-01-21 17:10:11 CST
" ====================================================
if exists('g:loaded_comment_vim_qsyxneop')
    \ || exists('g:no_load_plugins')
    finish
endif
let g:loaded_comment_vim_qsyxneop = 1

" let g:comment_plugin = 'commentary'
let g:comment_plugin = 'tcomment'

if get(g:, 'comment_plugin') ==# 'commentary'
    silent! packadd vim-commentary
    xmap <Leader>c          <Plug>Commentary
    nmap <Leader>c          <Plug>Commentary
    omap <Leader>c          <Plug>Commentary
    nmap <Leader>c<Space>   <Plug>CommentaryLine
    nmap <Leader>cu         <Plug>Commentary<Plug>Commentary
    if maparg('c','n') ==# '' && !exists('v:operator')
        nmap c<Leader>c     <Plug>ChangeCommentary
    endif
elseif get(g:, 'comment_plugin') ==# 'tcomment'
    silent! packadd tcomment_vim
    " Add additional mappings for nerdcomment muscle memory
    xmap <silent><Leader>c          <Plug>TComment_gc
    nmap <Leader>c<Space>           <Plug>TComment_gcc
    omap <silent><Leader>c          <Plug>TComment_gc
endif
