let s:guard = "g:loaded_autoload_plugins_diagnostic_nvim" | if exists(s:guard) | finish | endif
let {s:guard} = 1

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_insert_delay = 1

nnoremap <silent> [q :NextDiagnosticCycle<CR>
nnoremap <silent> ]q :PrevDiagnosticCycle<CR>
