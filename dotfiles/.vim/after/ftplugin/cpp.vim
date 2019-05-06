" C++ filetype commands
"
set foldmethod=marker
setlocal shiftwidth=4
setlocal tabstop=4
setlocal expandtab

let g:quickfix_open = 24

if exists('g:AutoPairs')
    let b:AutoPairs = AutoPairsDefine({'<' : '>'}, [])
endif
