" Git Commit Messages

" Turn autocomplete off if plugin is loaded
if exists('g:loaded_deoplete')
    call deoplete#custom#buffer_option(
        \ 'auto_complete',
        \ v:false
        \ )
endif
