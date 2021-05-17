" Use vim-surround keybindings
" See https://github.com/machakann/vim-sandwich/blob/master/macros/sandwich/keymap/surround.vim
let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1
let g:textobj_sandwich_no_default_key_mappings = 1

nmap ys <Plug>(operator-sandwich-add)
onoremap <SID>line :normal! ^vg_<CR>
nmap <silent> yss <Plug>(operator-sandwich-add)<SID>line
onoremap <SID>gul g_
nmap yS ys<SID>gul

nmap ds <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap dss <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
nmap cs <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap css <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

xmap S <Plug>(operator-sandwich-add)

runtime autoload/repeat.vim
if hasmapto('<Plug>(RepeatDot)')
    nmap . <Plug>(operator-sandwich-predot)<Plug>(RepeatDot)
else
    nmap . <Plug>(operator-sandwich-dot)
endif
