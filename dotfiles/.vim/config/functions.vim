" vim:set fdl=1:
"    __                  _   _                       _
"   / _|_   _ _ __   ___| |_(_) ___  _ __  _____   _(_)_ __ ___
"  | |_| | | | '_ \ / __| __| |/ _ \| '_ \/ __\ \ / / | '_ ` _ \
"  |  _| |_| | | | | (__| |_| | (_) | | | \__ \\ V /| | | | | | |
"  |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___(_)_/ |_|_| |_| |_|
"
" TODO: move these to canonical vim folders (plugin,ftplugin,autoload,indent)
" Functions {{{1
" " File operations {{{2
" " GetProjectRoot() :: get the root path based on git or parent folder {{{3
" function! GetProjectRoot() abort
"     " Check if this has already been defined
"     if exists('b:project_root_dir')
"         return b:project_root_dir
"     endif
"     packadd vim-rooter
"     if exists('*FindRootDirectory')
"         let l:root = FindRootDirectory()
"     else
"         " Get root from git or file parent dir
"         let l:root = substitute(system('git rev-parse --show-toplevel'), '\n\+$', '', '')
"         if ! isdirectory(l:root)
"             let l:root = expand('%:p:h')
"         endif
"     endif
"     " Save root in buffer local variable
"     let b:project_root_dir = l:root
"     return b:project_root_dir
" endfunction
"
" " GetRootFolderName() :: get just the name of the folder {{{3
" function! GetRootFolderName() abort
"     let l:root = GetProjectRoot()
"     return matchstr(l:root, '[^\/\\]*$')
" endfunction
"
" " SetProjectRoot() :: set vim cwd to project root dir {{{3
" " set working directory to git project root
" " or directory of current file if not git project
" function! SetProjectRoot() abort
"     let l:root_dir = GetProjectRoot()
"     lcd `=l:root_dir`
" endfunction
"
" Quickfix window {{{2
" ToggleQf() :: toggle quickfix window {{{3
function! ToggleQf() abort
    if exists('*asyncrun#quickfix_toggle')
        " AsyncRun is loaded; use this handy function
        " Open qf window of specific size in most elegant way
        let qf_lines = len(getqflist())
        let qf_size = qf_lines ?
            \ min([qf_lines, get(g:, 'quickfix_size', 12)]) :
            \ 1
        call asyncrun#quickfix_toggle(qf_size)
        return
    endif
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
          " then it should be the quickfix window
          cclose
          return
        endif
    endfor
    " Quickfix window not open, so open it
    copen
endfunction

" CloseEmptyQf() :: close an empty quickfix window {{{3
function! CloseEmptyQf() abort
    if len(getqflist())
        return
    endif
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
            call ToggleQf()
            return
        endif
    endfor
endfunction

" IsQfOpen() :: check if quickfix window is open {{{3
function! IsQfOpen() abort
    for buffer in tabpagebuflist()
        if bufname(buffer) ==? ''
            return 1
        endif
    endfor
    return 0
endfunction

" AutoCloseQfWin() :: close qf on quit {{{3
function! AutoCloseQfWin() abort
    if &filetype ==? 'qf'
        " if this window is last on screen quit without warning
        if winnr('$') < 2
            quit
        endif
    endif
endfunction

" Building {{{2
" RunBuild() :: build/install current project
" function! RunBuild() abort
"     " Run build plugins
"     let s:ft_cmds = {
"         \ 'go': {
"         \   'cmd': 'AsyncRun go install',
"         \   'show_qf': 0
"         \  },
"         \ 'cpp': {
"         \   'cmd': 'AsyncRun -cwd=<root>/build make install',
"         \   'show_qf': 1
"         \  },
"         \ 'rust': {
"         \   'cmd': 'AsyncRun -cwd=<root> cargo install -f --path .',
"         \   'show_qf': 0
"         \  },
"         \ }
"     let s:ft = get(s:ft_cmds, &filetype, {})
"     let s:cmd = get(s:ft, 'cmd', '')
"     let s:qf_size = get(s:ft, 'show_qf', 0) * g:asyncrun_open
"     if s:cmd !=? ''
"         if s:cmd =~# 'AsyncRun'
"             let g:asyncrun_exit = 'call CheckRun("Build")'
"             let g:asyncrun_open = s:qf_size
"             execute s:cmd
"             return
"         endif
"         " Regular command
"         execute s:cmd
"         return
"     endif
" endfunction
"
" function! RunMakeInstall() abort
"     execute 'AsyncRun -cwd=<root>/build make install'
" endfunction

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

" Keyword documentation {{{2
" ShowDocumentation() :: use K for vim docs or language servers
function! ShowDocumentation() abort
    if &filetype ==# 'vim'
        execute 'h '.expand('<cword>')
    else
        if exists('g:did_coc_loaded')
            call CocActionAsync('doHover')
            return
        endif
    endif
endfunction
set keywordprg=:silent!\ call\ ShowDocumentation()

" General {{{2
" OpenTagbar() :: wrapper for tagbar#autoopen with options {{{3
function! OpenTagbar() abort
    if winwidth(0) > 100
        call tagbar#autoopen(0)
    else
        return
    endif
endfunction

" LastPlace() :: restore cursor position and folding {{{3
function! s:last_place()
    " Derived from and simplified:
    " https://github.com/farmergreg/vim-lastplace/blob/master/plugin/vim-lastplace.vim

    " Options
    let open_folds = 1

    " Folds flicker and close anyway when using Coc
    if exists('g:did_coc_loaded')
        let open_folds = 0
    endif
    let ignore_buftype = [
        \ 'quickfix',
        \ 'nofile',
        \ 'help',
        \ ]
    let ignore_filetype = [
        \ 'gitcommit',
        \ 'gitrebase',
        \ 'svn',
        \ 'hgcommit',
        \ ]

    " Check filetype and buftype against ignore lists
    if index(ignore_buftype, &buftype) != -1 ||
        \ index(ignore_filetype, &filetype) != -1
        return
    endif

    " Do nothing if file does not exist on disk
    try
        if empty(glob(@%))
            return
        endif
    catch
        return
    endtry

    let lastpos = line("'\"")
    let buffend = line('$')
    let winend = line('w$')
    let winstart = line('w0')

    if lastpos > 0 && lastpos <= line('$')
        " Last edit pos is set and is < no of lines in buffer
        if winend == buffend
            " Last line in buffer is also last line visible
            execute 'normal! g`"'
        elseif buffend - lastpos > ((winend - winstart) / 2) - 1
            " Center cursor on screen if not at bottom
            execute 'normal! g`"zz'
        else
            " Otherwise, show as much context as we can
            execute "normal! \G'\"\<c-e>"
        endif
    endif

    if foldclosed('.') != -1 && open_folds
        " Cursor was inside a fold; open it
        execute 'normal! zv'
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
" Cursor {{{2
" Remember last place in file
autocmd vimrc BufWinEnter * call <SID>last_place()

" Set cursorline depending on mode, if cursorline is enabled in vimrc
if &cursorline
    autocmd vimrc WinEnter,InsertLeave * set cursorline
    autocmd vimrc WinLeave,InsertEnter * set nocursorline
endif

" Line numbers {{{2
" Toggle to number mode depending on vim mode
" INSERT:       Turn off relativenumber while writing code
" NORMAL:       Turn on relativenumber for easy navigation
" NO FOCUS:     Turn off relativenumber (testing code, etc.)
" QuickFix:     Turn off relativenumber (running code)
" autocmd vimrc BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
" autocmd vimrc BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
" autocmd vimrc FileType qf if &nu | set nornu | endif

" Only turn off relativenumber during insert mode
" Put back to the above lines once coc.nvim floating window is fixed
autocmd vimrc InsertLeave * if &nu | set rnu   | endif
autocmd vimrc InsertEnter * if &nu | set nornu | endif

" Vim Fugitive {{{2
" Use AsyncRun
if exists('*asyncrun#execute')
    command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
endif

" Quickfix window {{{2
" Close buffer if quickfix window is last
" autocmd vimrc BufEnter * call AutoCloseQfWin()
" Push quickfix window always to the bottom
autocmd vimrc FileType qf wincmd J
" Close qf after lint if empty
autocmd vimrc User ALELintPost call CloseEmptyQf()

" Terminal {{{2
if has('nvim')
    " Start in TERMINAL mode (any key will exit)
    autocmd vimrc TermOpen * startinsert
    " `<Esc>` to exit terminal mode
    autocmd vimrc TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
    " Unmap <Esc> so it can be used to exit FZF
    autocmd vimrc FileType fzf tunmap <buffer> <Esc>
endif

" Formatopts {{{2
autocmd vimrc BufNewFile,BufRead * setlocal formatoptions-=o
