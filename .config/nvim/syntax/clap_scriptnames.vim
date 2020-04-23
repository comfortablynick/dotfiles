syntax match ClapScriptNr /^\s*\d\+/
syntax match ClapScriptname /^.$/ contains=ClapScriptNr

hi default link ClapScriptNr Number
hi default link ClapScriptname LineNr
