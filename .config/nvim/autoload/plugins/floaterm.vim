let g:floaterm_shell = $SHELL
let g:floaterm_wintitle = v:true
let g:floaterm_autoclose = v:true
" let g:floaterm_width = 0.7
" let g:floaterm_height = 0.6

hi link Floaterm NormalFloat
hi link FloatermBorder NormalFloat

nnoremap <silent> <F7> :FloatermToggle<CR>
tnoremap <silent> <F7> <C-\><C-n>:FloatermToggle<CR>

" plugins#floaterm#wrap :: Use floaterm for custom command and allow cmdline options {{{1
function! plugins#floaterm#wrap(cmd, ...)
    execute ':FloatermNew' join(a:000) a:cmd
endfunction

" Use floaterm for Async[Run|Tasks] {{{1
function! s:runner_proc(opts)
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
let g:asyncrun_runner['floaterm'] = function('s:runner_proc')
