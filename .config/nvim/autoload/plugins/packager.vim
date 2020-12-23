augroup plugins_packager_pre
    autocmd!
    autocmd FileType packager call s:packager_maps()
augroup END

function s:packager_maps()
    nmap <buffer> <Down> <Plug>(PackagerGotoNextPlugin)
    nmap <buffer> J      <Plug>(PackagerGotoNextPlugin)
    nmap <buffer> <Up>   <Plug>(PackagerGotoPrevPlugin)
    nmap <buffer> K      <Plug>(PackagerGotoPrevPlugin)
endfunction
