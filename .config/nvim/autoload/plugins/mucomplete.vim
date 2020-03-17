if exists('g:loaded_autoload_plugins_mucomplete') | finish | endif
let g:loaded_autoload_plugins_mucomplete = 1

function! plugins#mucomplete#pre() abort
    set completeopt+=menuone,noselect
    set shortmess+=c
    let g:mucomplete#enable_auto_at_startup = 1

    " Default chain presets
    let l:mu_default = ['path', 'ulti', 'omni', 'keyn',]
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

function! plugins#mucomplete#post() abort
    imap <expr> <down> mucomplete#extend_fwd("\<down>")
endfunction
