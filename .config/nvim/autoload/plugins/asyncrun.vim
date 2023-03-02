let g:asyncrun_open              = 0                              " Show quickfix when executing command
let g:asyncrun_bell              = 0                              " Ring bell when job finished
let g:quickfix_run_scroll        = 0                              " Scroll when running code
let g:asyncrun_raw_output        = 0                              " Don't process errors on output
let g:asyncrun_save              = 0                              " Save file before running
let g:asyncrun_runner            = get(g:, 'asyncrun_runner', {}) " Custom runners
let g:asyncrun_runner.floaterm   = {o -> s:floaterm_runner(o)}    " Run in floaterm with `-pos=floaterm`
let g:asyncrun_runner.tmux_split = {o ->     s:tmux_runner(o)}    " Run in floaterm with `-pos=tmux_split` (`-pos=tmux` is overridden)
let g:asyncrun_rootmarks = [
    \ '.git',
    \ '.svn',
    \ '.project',
    \ '.root',
    \ '.hg',
    \ 'justfile',
    \ '.tasks',
    \ 'tasks.ini',
    \ 'Taskfile.yml',
    \ 'cargo.toml',
    \ 'go.mod',
    \ ]

command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" Floaterm Runner {{{1
function s:floaterm_runner(opts)
    let g:ft_opts = a:opts
    let l:cmd = 'FloatermNew '
    let l:cmd ..= ' --wintype=float'
    if has_key(a:opts, 'position') 
        let l:cmd ..= ' --position=' .. fnameescape(a:opts.position)
    endif
    if has_key(a:opts, 'width')
        let l:cmd ..= ' --width=' .. fnameescape(a:opts.width)
    endif
    if has_key(a:opts, 'height')
        let l:cmd ..= ' --height=' .. fnameescape(a:opts.height)
    endif
    if has_key(a:opts, 'title')
        let l:cmd .= ' --title=' .. fnameescape(a:opts.title)
    endif
    let l:cmd ..= ' --autoclose=0'
    let l:cmd ..= ' --silent=' .. get(a:opts, 'silent', 0)
    " use temp file for precise argument passing and shell builtins
    let l:cmd ..= ' ' .. fnameescape(asyncrun#script_write(a:opts.cmd, 0))
    execute l:cmd
    if !get(a:opts, 'focus', 1)
        noautocmd wincmd p
        " TODO: Doesn't work for some reason
        augroup close-floaterm-runner
            autocmd!
            autocmd CursorMoved,InsertEnter * ++nested
                \ call timer_start(100, {->s:floaterm_close()})
        augroup END
    endif
endfunction

function s:floaterm_close() abort
    if &filetype ==# 'floaterm' | return | endif
    for l:b in tabpagebuflist()
        if getbufvar(l:b, '&ft') ==# 'floaterm' &&
            \ getbufvar(l:b, 'floaterm_jobexists') == v:false
            execute l:b 'bwipeout!'
            break
        endif
    endfor
    autocmd! close-floaterm-runner
endfunction

" Tmux Runner {{{1
function s:tmux_runner(opts)
    execute 'VtrSendCommandToRunner!' a:opts.cmd
endfunction
