syntax match ClapScriptNr /^\s*\d\+:/
syntax match ClapScriptname /\s.*$/ contains=ClapScriptNr

hi default link ClapScriptNr Number
hi default link ClapScriptname Identifier
