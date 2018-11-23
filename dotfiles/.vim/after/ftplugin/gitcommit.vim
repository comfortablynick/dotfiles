" Git Commit Messages

" Start in INSERT mode
exec 'au VimEnter * startinsert'

" Turn autocomplete off
if has("nvim")
    call deoplete#custom#buffer_option(
        \ 'auto_complete',
        \ v:false
        \ )
endif
