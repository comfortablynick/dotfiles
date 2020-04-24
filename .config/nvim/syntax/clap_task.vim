syntax match ClapTaskName /^\S\+/
syntax match ClapTaskScope /\s\+<\w\+>\s\+:/
" syntax match ClapTaskScope /^.$/ contains=ClapTaskName

hi default link ClapTaskName Number
hi default link ClapTaskScope Typedef
