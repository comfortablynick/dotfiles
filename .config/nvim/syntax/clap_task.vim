" Not sure exactly why this works, but I'm not complaining
syntax match ClapTaskName /^\S\+/
syntax match ClapTaskDetails /\s\+<\w\+>\s\+:.*$/ contains=ClapTaskScope,ClapTask
syntax match ClapTaskScope /\s\+<\w\+>\s\+:/ contained
syntax match ClapTask /^.$/ contained

hi default link ClapTaskName Keyword
hi default link ClapTaskScope Number
hi default link ClapTaskDetails Statement
