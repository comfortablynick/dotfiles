let g:floaterm_shell = $SHELL
let g:floaterm_wintitle = v:true

" 0 Always do NOT close floaterm window
" 1 Close window only if the job exits normally
" 2 Always close floaterm window
let g:floaterm_autoclose = 1

" hi link Floaterm NormalFloat
" hi link FloatermBorder NormalFloat
augroup autoload_plugins_floaterm
    autocmd!
    autocmd FileType floaterm call s:floaterm_ft()
augroup END

function s:floaterm_ft()
    tnoremap <buffer><silent><F7>  <C-\><C-n>:FloatermToggle<CR>
    tnoremap <buffer><silent><Esc> <C-\><C-n>:FloatermKill<CR>
    tnoremap <buffer><silent><C-c> <C-\><C-n>:FloatermKill<CR>
endfunction

nnoremap <silent><F7> :FloatermToggle<CR>

" Use floaterm for Async[Run|Tasks] {{{1
function s:runner_proc(opts)
    let l:curr_bufnr = floaterm#curr()
    if has_key(a:opts, 'silent') && a:opts.silent == 1
        call floaterm#hide()
    endif
    let l:cmd = 'cd '.shellescape(getcwd())
    call floaterm#terminal#send(l:curr_bufnr, [l:cmd])
    call floaterm#terminal#send(l:curr_bufnr, [a:opts.cmd])
    stopinsert
    if &filetype ==# 'floaterm' && g:floaterm_autoinsert
        call floaterm#util#startinsert()
    endif
endfunction

let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
let g:asyncrun_runner['floaterm'] = {o -> s:runner_proc(o)}
