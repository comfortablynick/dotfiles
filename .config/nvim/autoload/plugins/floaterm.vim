let s:guard = 'g:loaded_autoload_plugins_floaterm' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#floaterm#post() abort
    " let g:floaterm_wintitle = v:false

    hi link Floaterm NormalFloat
    hi link FloatermBorder NormalFloat
endfunction

" Use floaterm for custom command and allow cmdline options
function! plugins#floaterm#wrap(cmd, ...) abort
    execute ':FloatermNew' join(a:000) a:cmd
endfunction

function! s:runner_proc(opts)
  let l:curr_bufnr = floaterm#curr()
  if has_key(a:opts, 'silent') && a:opts.silent == 1
    call floaterm#hide()
  endif
  let l:cmd = 'cd ' . shellescape(getcwd())
  call floaterm#terminal#send(l:curr_bufnr, [l:cmd])
  call floaterm#terminal#send(l:curr_bufnr, [a:opts.cmd])
  stopinsert
  if &filetype ==# 'floaterm' && g:floaterm_autoinsert
    call floaterm#util#startinsert()
  endif
endfunction

let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
let g:asyncrun_runner.floaterm = function('s:runner_proc')
