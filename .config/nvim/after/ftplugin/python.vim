setlocal smartindent
setlocal autoindent
setlocal foldmethod=marker
setlocal formatprg=black\ -q\ -

let g:python_highlight_all=1
let $PYTHONUNBUFFERED=1

" Don't overwrite command if already defined
silent! command Black call plugins#lazy_run('Black', 'black')

nnoremap <buffer><silent><F3> :call <SID>format_python()<CR>

function! s:format_python() abort
    Black
    if g:coc_enabled == 1
        call CocAction('runCommand', 'editor.action.organizeImport')
    endif
endfunction

" Preserve existing doge settings.
let b:doge_patterns = get(b:, 'doge_patterns', {})
let b:doge_supported_doc_standards = get(b:, 'doge_supported_doc_standards', [])
if index(b:doge_supported_doc_standards, 'numpy_untyped') < 0
    call add(b:doge_supported_doc_standards, 'numpy_untyped')
endif

" Set the new doc standard as default.
let b:doge_doc_standard = 'numpy_untyped'

" Ensure we do not overwrite an existing doc standard.
if !has_key(b:doge_patterns, 'numpy_untyped')
    let b:doge_patterns['numpy_untyped'] = b:doge_patterns['numpy']
    let b:doge_patterns['numpy_untyped'][0]['parameters']['format'][0] = 
        \ '{name}'
    call remove(b:doge_patterns['numpy_untyped'][0]['template'], 0, 2)
    let b:doge_patterns['numpy_untyped'][0]['template'][0] = '"""'..
        \ b:doge_patterns['numpy_untyped'][0]['template'][0]
endif
