" Build command based on file type and command type
function! runner#run_cmd(cmd_type) abort
    let l:cmd = 'just '.a:cmd_type

    " Decide where to run the command
    let l:run_loc = exists('b:run_cmd_in') ?
        \ b:run_cmd_in :
        \ get(g:, 'run_cmd_in', runner#get_cmd_run_loc())

    if l:run_loc ==# 'term'
        call runner#run_in_term(l:cmd)
    elseif l:run_loc ==# 'AsyncRun'
        return
    elseif l:run_loc ==# 'Vtr'
        execute 'VtrSendCommandToRunner! ' . l:cmd
        return
    endif
endfunction

" Send cmd output to integrated terminal buffer
function! runner#run_in_term(cmd) abort
    let s:mod = winwidth(0) > 150 ? 'vsplit' : 'split'
    execute s:mod . '|term ' . a:cmd
    return
endfunction

" Determine default command output
function! runner#get_cmd_run_loc() abort
    if !empty($TMUX_PANE) && winwidth(0) > 200
        let b:run_cmd_in = 'Vtr'
        return 'Vtr'
    endif
    let b:run_cmd_in = 'term'
    return 'term'
endfunction
