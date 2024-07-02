" vint: -ProhibitAutocmdWithNoGroup
autocmd BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
" autocmd BufRead,BufNewFile .clang-format,.prettierrc,.yamllint,.ansible-lint setfiletype yaml
" autocmd BufNewFile,BufRead *.yml,*.yaml,*/{group,host}_vars/* if s:is_ansible() | set ft=yaml.ansible | endif

" Don't need this if ansible ftplugin is installed
" function s:is_ansible()
"     if &filetype =~# 'ansible' | return | endif
"     let l:filepath = expand('%:p')
"     let l:filename = expand('%:t')
"     if l:filepath =~# '\v/(tasks|roles|handlers|playbooks)/.*\.ya?ml$' | return 1 | end
"     if l:filepath =~# '\v/(group|host)_vars/' | return 1 | end
"     if l:filename =~# '\v(playbook|site|main|local|requirements)\.ya?ml$' | return 1 | end
"
"     let l:shebang = getline(1)
"     if l:shebang =~# '^#!.*/bin/env\s\+ansible-playbook\>' | return 1 | end
"     if l:shebang =~# '^#!.*/bin/ansible-playbook\>' | return 1 | end
"     return 0
" endfunction
