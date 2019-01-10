" Settings for Python files

" PEP8 Compatibile Indenting
setlocal expandtab                          " Expand tab to spaces
setlocal smartindent                        " Attempt smart indenting
setlocal autoindent                         " Attempt auto indenting
setlocal shiftwidth=4                       " Indent width in spaces
setlocal softtabstop=4
setlocal tabstop=4
setlocal foldmethod=marker                  " Use 3x{ for folding

" Other
setlocal backspace=2                        " Backspace behaves as expected
let python_highlight_all=1                  " Highlight all builtins
let $PYTHONUNBUFFERED=1                     " Disable stdout buffering

" Map
" " Execute current file with AsyncRun
" " TODO: evaluate if > 1 pane in TMUX
" function! UseQuickFix() abort
"     if $TMUX_SESSION ==? 'ios'
"         if g:window_width < 120
"             return 1
"         else
"             return 0
"         endif
"     elseif exists('$TMUX')
"         return 0
"     endif
" endfunction
" 
" if exists('*asyncrun#quickfix_toggle')
"     function! AsyncRun_Python_Cmd() abort
"         if UseQuickFix()
"             let scroll = get(g:, 'quickfix_run_scroll', 1)
"             let raw = get(g:, 'asyncrun_raw_output', 0)
"             let cmd = scroll ? ':AsyncRun' : ':AsyncRun!'
"             let raw_cmd = raw ? ' -raw' : ''
"             return cmd . raw_cmd . ' python3 % <CR>'
"         else
"             let g:asyncrun_open = 0
"             let g:asyncrun_save = 1
"             return ':AsyncRun tmux send-keys -t right C-l "python3 $(VIM_FILEPATH)" C-m<CR>'
"         endif
"     endfunction
" 
"     " TODO: only execute if available pane OR open new split
"     execute 'nnoremap <silent> <C-b> ' . AsyncRun_Python_Cmd()
"     nnoremap <silent> <C-x> :call ToggleQf()<CR>
" else
"     nnoremap <silent> <C-b> :call SaveAndExecutePython()<CR>
"     nnoremap <silent> <C-x> :call ClosePythonWindow()<CR>
" endif
" 
" " Define fold rules for coiledsnake
" function! g:CoiledSnakeConfigureFold(fold)
"     " Don't fold nested classes.
"     if a:fold.type ==? 'class'
"         let a:fold.max_level = 1
" 
"     " Don't fold nested functions, but do fold methods (i.e. functions
"     " nested inside a class).
"     elseif a:fold.type ==? 'function'
"         let a:fold.max_level = 1
"         if get(a:fold.parent, 'type') == 'class'
"             let a:fold.max_level = 2
"         endif
" 
"     " Only fold imports if there are n or more of them.
"     elseif a:fold.type ==? 'import'
"         let a:fold.min_lines = 6
"     endif
" 
"     " Don't fold anything if the whole program is shorter than 30 lines.
"     if line('$') < 30
"         let a:fold.ignore = 1
"     endif
" 
"     let a:fold.num_blanks_below = 2
" endfunction
