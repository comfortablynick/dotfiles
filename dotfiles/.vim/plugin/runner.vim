if exists('g:loaded_runner_vim')
    finish
endif
let g:loaded_runner_vim = 1

" Build command based on file type and command type
function! runner#run_cmd(cmd_type) abort
    " Preface commands with space to exclude from fish history
    let l:ft_cmds = get(b:, 'ft_cmds', {
        \ 'go': {
        \   'build': ' go install && go run .',
        \   'install': ' go install && go run .',
        \   'run': ' go run .',
        \  },
        \ 'cpp': {
        \   'build': ' pushd build && make install; popd',
        \   'install': ' pushd build && make install; popd',
        \   'run': ' pushd build && make install; popd && ' . files#get_root_folder_name(),
        \  },
        \ 'c': {
        \   'build': ' pushd build && make install; popd',
        \   'install': ' pushd build && make install; popd',
        \   'run': ' pushd build && make install; popd && ' . files#get_root_folder_name(),
        \  },
        \ 'rust': {
        \   'build': ' cargo build',
        \   'build-release': ' cargo build --release',
        \   'install': ' cargo install -f --path .',
        \   'run': ' cargo run',
        \  },
        \ 'python': {
        \   'build': ' python ' . expand('%'),
        \   'install': ' python ' . expand('%'),
        \   'run': ' python ' . expand('%'),
        \ },
        \ 'typescript': {
        \   'build': 'clasp push',
        \   'install': 'clasp push',
        \   'run': 'clasp run',
        \ }
        \ })
    let l:ft = get(l:ft_cmds, &filetype, {})
    let l:cmd = get(l:ft, a:cmd_type, '')
    if l:ft ==# {} || l:cmd ==# ''
        if index([ 'build', 'install', 'run' ], l:cmd) == 0
            " not a valid command
            return
        endif
        let l:cmd = a:cmd_type
    endif

    " Decide where to run the command
    let l:run_loc = exists('b:run_cmd_in') ?
        \ b:run_cmd_in :
        \ get(g:, 'run_cmd_in', runner#get_cmd_run_loc())

    call files#set_project_root()
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
