scriptencoding utf-8

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_insert_delay = 1

call sign_define("LspDiagnosticsErrorSign",       {"text" : '✖', 'texthl' : 'LspDiagnosticsError'})
call sign_define('LspDiagnosticsWarningSign',     {'text' : '‼', 'texthl' : 'LspDiagnosticsWarning'})
call sign_define('LspDiagnosticsInformationSign', {'text' : 'i', 'texthl' : 'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsHintSign',        {'text' : '»', 'texthl' : 'LspDiagnosticsHint'})


nnoremap <buffer> <silent> ]q :NextDiagnosticCycle<CR>
nnoremap <buffer> <silent> [q :PrevDiagnosticCycle<CR>

function! s:set_hi()
    highlight LspDiagnosticsError       ctermfg=Red guifg=#ff5f87
    highlight LspDiagnosticsWarning     ctermfg=178 guifg=#d78f00
    highlight LspDiagnosticsInformation ctermfg=178 guifg=#d78f00
    highlight LspDiagnosticsHint        ctermfg=178 guifg=#ff5f87 gui=bold
    highlight LspDiagnosticsUnderline   ctermfg=Red guifg=Red
    hi link   LspDiagnosticsUnderlineError LspDiagnosticsError
endfunction

augroup autoload_plugins_diagnostic
    autocmd!
    autocmd ColorScheme * call s:set_hi()
augroup END
