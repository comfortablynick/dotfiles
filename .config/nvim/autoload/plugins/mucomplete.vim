set completeopt+=menuone,noselect
set shortmess+=c
let g:mucomplete#enable_auto_at_startup = 1

" let g:mucomplete#wordlist = {
"     \ 'chordpro': Chords(),
"     \ }

" Default chain presets
" call mucomplete#add_user_mapping('chord', "\<C-R>=ChordComplete()\<CR>")
let s:mu_default = ['list', 'path', 'ulti', 'omni', 'user', 'keyn']
let s:mu_text_default = s:mu_default "+ ['dict', 'uspl']

let g:mucomplete#chains = {
    \ 'default': s:mu_default,
    \ 'python': {
    \     'pythonString': [],
    \     'pythonComment': ['dict', 'uspl'],
    \   },
    \ 'markdown': {
    \     'default': s:mu_text_default,
    \   },
    \ 'asciidoctor': {
    \     'default': s:mu_text_default,
    \   },
    \ 'text': {
    \     'default': s:mu_text_default,
    \   },
    \ 'toml': {
    \     'default': s:mu_text_default,
    \   },
    \ 'vim': {
    \     'default': s:mu_default,
    \   },
    \ }

imap <expr> <Down> mucomplete#extend_fwd("\<Down>")
