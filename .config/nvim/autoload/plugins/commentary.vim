xmap <Leader>c          <Plug>Commentary
nmap <Leader>c          <Plug>Commentary
omap <Leader>c          <Plug>Commentary
nmap <Leader>c<Space>   <Plug>CommentaryLine
nmap <Leader>cu         <Plug>Commentary<Plug>Commentary
if maparg('c','n') ==# '' && !exists('v:operator')
    nmap c<Leader>c     <Plug>ChangeCommentary
endif
