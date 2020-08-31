let s:guard = 'g:loaded_autoload_plugins_easymotion' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#easymotion#pre() abort
    " <Leader>f{char} to move to {char}
    map  f <Plug>(easymotion-bd-f)
    nmap f <Plug>(easymotion-overwin-f)

    " s{char}{char} to move to {char}{char}
    nmap s <Plug>(easymotion-overwin-f2)

    " Move to line
    map L <Plug>(easymotion-bd-jk)
    nmap L <Plug>(easymotion-overwin-line)

    " Move to word
    map  <Leader>w <Plug>(easymotion-bd-w)
    nmap <Leader>w <Plug>(easymotion-overwin-w)
endfunction
