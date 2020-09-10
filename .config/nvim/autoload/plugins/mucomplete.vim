let s:guard = 'g:loaded_autoload_plugins_mucomplete' | if exists(s:guard) | finish | endif
let {s:guard} = 1

function! plugins#mucomplete#pre() abort
    set completeopt+=menuone,noselect
    set shortmess+=c
    let g:mucomplete#enable_auto_at_startup = 1

    " let g:mucomplete#wordlist = {
    "     \ 'chordpro': Chords(),
    "     \ }

    " Default chain presets
    " call mucomplete#add_user_mapping('chord', "\<C-R>=ChordComplete()\<CR>")
    let l:mu_default = ['list', 'path', 'ulti', 'omni', 'user', 'keyn']
    let l:mu_text_default = l:mu_default "+ ['dict', 'uspl']

    let g:mucomplete#chains = {
        \ 'default': l:mu_default,
        \ 'python': {
        \     'pythonString': [],
        \     'pythonComment': ['dict', 'uspl'],
        \   },
        \ 'markdown': {
        \     'default': l:mu_text_default,
        \   },
        \ 'asciidoctor': {
        \     'default': l:mu_text_default,
        \   },
        \ 'text': {
        \     'default': l:mu_text_default,
        \   },
        \ 'toml': {
        \     'default': l:mu_text_default,
        \   },
        \ 'vim': {
        \     'default': l:mu_default,
        \   },
        \ }
endfunction

imap <expr> <down> mucomplete#extend_fwd("\<down>")
