" vim:set fdl=1:
"    __                  _   _                       _
"   / _|_   _ _ __   ___| |_(_) ___  _ __  _____   _(_)_ __ ___
"  | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __\ \ / / | '_ ` _ \
"  |  _| |_| | | | | (__| |_| | (_) | | | \__ \\ V /| | | | | | |
"  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___(_)_/ |_|_| |_| |_|
"
" TODO: move these to canonical vim folders (plugin,ftplugin,autoload,indent)
" AsyncRun
" CheckRun() :: check AsyncRun return code
" function! CheckRun(cmdName) abort
"    if g:asyncrun_status ==? 'success'
"        echo a:cmdName . ' completed successfully'
"        return
"    endif
"    if g:asyncrun_status ==? 'failure'
"        if IsQfOpen() == 0
"            call ToggleQf()
"        endif
"        echo a:cmdName . ' failed. Check quickfix for details'
"        return
"    endif
" endfunction


" (Auto)commands
" Terminal
" if has('nvim')
"     " Start in TERMINAL mode (any key will exit)
"     autocmd vimrc TermOpen * startinsert
"     " `<Esc>` to exit terminal mode
"     autocmd vimrc TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
"     " Unmap <Esc> so it can be used to exit FZF
"     autocmd vimrc FileType fzf tunmap <buffer> <Esc>
" endif
