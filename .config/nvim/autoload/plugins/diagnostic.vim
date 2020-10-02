scriptencoding utf-8

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ''
let g:diagnostic_insert_delay = 1

call sign_define("LspDiagnosticsErrorSign",       {"text" : 'E', 'texthl' : 'LspDiagnosticsError'})
call sign_define('LspDiagnosticsWarningSign',     {'text' : 'W', 'texthl' : 'LspDiagnosticsWarning'})
call sign_define('LspDiagnosticsInformationSign', {'text' : 'i', 'texthl' : 'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsHintSign',        {'text' : '?', 'texthl' : 'LspDiagnosticsHint'})


nnoremap <buffer> <silent> ]q :NextDiagnosticCycle<CR>
nnoremap <buffer> <silent> [q :PrevDiagnosticCycle<CR>

function s:set_hi()
    hi LspDiagnosticsError ctermfg=Red guifg=#ff5f87
    hi LspDiagnosticsWarning ctermfg=178 guifg=#d78f00
    hi LspDiagnosticsInformation ctermfg=178 guifg=#d78f00
    hi LspDiagnosticsHint ctermfg=178 guifg=#d78f00
    hi LspDiagnosticsUnderline ctermfg=Red guifg=Red
    hi link LspDiagnosticsUnderlineError LspDiagnosticsError
endfunction

augroup autoload_plugins_diagnostic
    autocmd!
    autocmd ColorScheme * call s:set_hi()
augroup END
