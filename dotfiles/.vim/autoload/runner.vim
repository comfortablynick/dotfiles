" ====================================================
" Filename:    autoload/runner.vim
" Description: Run code actions based on justfile
" Author:      Nick Murphy
" License:     MIT
" Last Change: 2020-01-21 19:02:24 CST
" ====================================================

" Build command based on file type and command type
function! runner#run_cmd(cmd_type) abort
    let l:cmds = get(g:, 'runner_cmd_overrides', {})
    let l:cmd = get(l:cmds, &filetype, 'just '.a:cmd_type)
    let l:cmd = substitute(l:cmd, '{file}', expand('%'), 'g')
    let l:run_loc = runner#get_cmd_run_loc()
    if l:run_loc ==? 'term'
        let b:runner_term_scale = get(b:, 'runner_term_scale', 50)
        " call luaeval('require"window".float_term(_A.cmd, _A.scale)',
        "     \ {'cmd': l:cmd, 'scale': b:runner_term_scale})
        call luaeval("require'window'.floating_terminal(_A)", l:cmd)
    elseif l:run_loc ==? 'AsyncRun'
        packadd asyncrun.vim
        execute 'AsyncRun '.l:cmd
        return
    elseif l:run_loc ==? 'Vtr'
        packadd vim-tmux-runner
        execute 'VtrSendCommandToRunner! '.l:cmd
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
    if !exists('b:run_cmd_in')
        if exists('g:run_cmd_in')
            let b:run_cmd_in = g:run_cmd_in
        elseif !empty($TMUX_PANE) && winwidth(0) > 200
            let b:run_cmd_in = 'Vtr'
        else
            " Use built-in terminal
            let b:run_cmd_in = 'term'
        endif
    endif
    return b:run_cmd_in
endfunction
