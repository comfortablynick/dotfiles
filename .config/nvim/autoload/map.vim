" NOTE: cannot be converted to lua because it won't support lua callbacks
" s:safe_abbr() :: Safe expansion of command-line abbreviations
function s:safe_cabbr(lhs, rhs)
    if getcmdtype() ==# ':' && getcmdline() ==# a:lhs
        if type(a:rhs) == v:t_func
            return a:rhs()
        endif
        return a:rhs
    endif
    return a:lhs
endfunction

" map#set_cabbr() :: Create safe cnoreabbrev
function map#set_cabbr(from, to)
    execute printf('cnoreabbrev <expr> %s getcmdtype() ==# ":" && getcmdline() ==# %s ? %s : %s',
        \ a:from,
        \ string(a:from),
        \ string(a:to),
        \ string(a:from),
        \ )
endfunction

function map#cabbr(lhs, rhs)
    execute printf('cnoreabbrev <expr> %s <SID>safe_cabbr(%s, %s)',
        \ a:lhs,
        \ string(a:lhs),
        \ string(a:rhs),
        \ )
endfunction

" map#eatchar() :: Eat character if it matches pattern
" From :helpgrep Eatchar
function map#eatchar(pat)
    let l:c = nr2char(getchar(0))
    return (l:c =~ a:pat) ? '' : l:c
endfunction

" map#check_back_space() :: Helper for tab mappings and completion
function map#check_back_space()
  let l:col = col('.') -1
  return !l:col || getline('.')[l:col - 1] =~# '\s'
endfunction
