" vint: -ProhibitAutocmdWithNoGroup
autocmd BufNewFile,BufRead *.yml,*.yaml,*/{group,host}_vars/*  call s:SelectAnsible("ansible")
" autocmd BufNewFile,BufRead hosts call s:SelectAnsible("ansible_hosts")

function! s:SelectAnsible(fileType)
  " Bail out if 'filetype' is already set to 'ansible'.
  if index(split(&filetype, '\.'), 'ansible') != -1
    return
  endif

  let fp = expand('<afile>:p')
  let dir = expand('<afile>:p:h')

  " Check if buffer is file under any directory of a 'roles' directory
  " or under any *_vars directory
  if fp =~? '/roles/.*\.y\(a\)\?ml$' || fp =~? '/\(group\|host\)_vars/'
    execute 'set filetype=yaml.' . a:fileType
    return
  endif

  " Check if subdirectories in buffer's directory match Ansible best practices
  if v:version < 704
    let directories=split(glob(fnameescape(dir) . '/{,.}*/', 1), '\n')
  else
    let directories=glob(fnameescape(dir) . '/{,.}*/', 1, 1)
  endif

  call map(directories, 'fnamemodify(v:val, ":h:t")')

  for dir in directories
    if dir =~? '\v^%(group_vars|host_vars|roles)$'
      execute 'set filetype=' . a:fileType
      return
    endif
  endfor
endfunction
