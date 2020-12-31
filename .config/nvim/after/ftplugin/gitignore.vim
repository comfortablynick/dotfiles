nnoremap <buffer> <Localleader>n <Cmd>call gitignore#negate()<CR>
let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
let b:undo_ftplugin .= '|nunmap <buffer> <Localleader>n'
