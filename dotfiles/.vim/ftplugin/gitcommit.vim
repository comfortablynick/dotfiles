" Git Commit Messages

" Start in INSERT mode
exec 'au VimEnter * startinsert'

" Turn autocomplete off
call deoplete#custom#buffer_option(
    \ 'auto_complete',
    \ v:false
    \ )
