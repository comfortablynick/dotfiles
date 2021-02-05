" vint: -ProhibitAutocmdWithNoGroup

autocmd BufRead,BufNewFile .prettierrc setfiletype yaml
autocmd BufRead,BufNewFile */{tasks,roles,handlers}/*.{yaml,yml} call s:set_yaml_ansible_filetype()
autocmd BufRead,BufNewFile */{group,host}_vars/* call s:set_yaml_ansible_filetype()

function s:set_yaml_ansible_filetype()
    if &filetype !=# 'yaml.ansible'
        set filetype=yaml.ansible
    endif
endfunction
