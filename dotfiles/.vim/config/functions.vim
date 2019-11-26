" vim:set fdl=1:
"    __                  _   _                       _
"   / _|_   _ _ __   ___| |_(_) ___  _ __  _____   _(_)_ __ ___
"  | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __\ \ / / | '_ ` _ \
"  |  _| |_| | | | | (__| |_| | (_) | | | \__ \\ V /| | | | | | |
"  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___(_)_/ |_|_| |_| |_|
"
" TODO: move these to canonical vim folders (plugin,ftplugin,autoload,indent)
" Functions {{{1
" AsyncRun {{{2
" CheckRun() :: check AsyncRun return code
function! CheckRun(cmdName) abort
   if g:asyncrun_status ==? 'success'
       echo a:cmdName . ' completed successfully'
       return
   endif
   if g:asyncrun_status ==? 'failure'
       if IsQfOpen() == 0
           call ToggleQf()
       endif
       echo a:cmdName . ' failed. Check quickfix for details'
       return
   endif
endfunction


" General {{{2
" OpenTagbar() :: wrapper for tagbar#autoopen with options {{{3
function! OpenTagbar() abort
    if winwidth(0) > 100
        call tagbar#autoopen(0)
    else
        return
    endif
endfunction

" BufWidth() :: get actual usable width of current buffer {{{3
function! BufWidth()
  let width = winwidth(0)
  let numberwidth = max([&numberwidth, strlen(line('$'))+1])
  let numwidth = (&number || &relativenumber)? numberwidth : 0
  let foldwidth = &foldcolumn

  if &signcolumn ==? 'yes'
    let signwidth = 2
  elseif &signcolumn ==? 'auto'
    let signs = execute(printf('sign place buffer=%d', bufnr('')))
    let signs = split(signs, "\n")
    let signwidth = len(signs)>2? 2: 0
  else
    let signwidth = 0
  endif
  return width - numwidth - foldwidth - signwidth
endfunction

" (Auto)commands {{{1
" Terminal {{{2
" if has('nvim')
"     " Start in TERMINAL mode (any key will exit)
"     autocmd vimrc TermOpen * startinsert
"     " `<Esc>` to exit terminal mode
"     autocmd vimrc TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
"     " Unmap <Esc> so it can be used to exit FZF
"     autocmd vimrc FileType fzf tunmap <buffer> <Esc>
" endif

" Formatopts {{{2
" autocmd vimrc BufNewFile,BufRead * setlocal formatoptions-=o
