scriptencoding utf-8

" Add additional rustTrait
syntax keyword rustTrait        PathBuf
syntax keyword rustIdentifier   Error
" Conceal operators (only if g:rust_conceal = 1) {{{
if !get(g:, 'rust_conceal', 0) || !has('conceal') || &encoding !=# 'utf-8'
    finish
endif

" For those who don't want to see `::`...
" cchar=ㆍ
if get(g:, 'rust_conceal_mod_path', 0)
    syn match rustNiceOperator "::" conceal cchar=ㆍ
endif

syn match rustRightArrowHead contained ">" conceal cchar= 
syn match rustRightArrowTail contained "-" conceal cchar=→
syn match rustNiceOperator "->" contains=rustRightArrowHead,rustRightArrowTail

syn match rustFatRightArrowHead contained ">" conceal cchar= 
syn match rustFatRightArrowTail contained "=" conceal cchar=⇒
syn match rustNiceOperator "=>" contains=rustFatRightArrowHead,rustFatRightArrowTail

syn match rustNiceOperator /\<\@!_\(_*\>\)\@=/ conceal cchar=′

syn keyword rustKeyword fn conceal cchar=ƒ

" For those who don't want to see `pub`...
if get(g:, 'rust_conceal_pub', 0)
    syn match rustPublicSigil contained "pu" conceal cchar=＊
    syn match rustPublicRest contained "b" conceal cchar= 
    syn match rustNiceOperator "pub " contains=rustPublicSigil,rustPublicRest
endif

hi link rustNiceOperator Operator

if !get(g:, 'rust_conceal_mod_path', 0)
    hi! link Conceal Operator

    augroup rust.vim.after
        autocmd!
        " And keep it after a colorscheme change
        autocmd ColorScheme <buffer> hi! link Conceal Operator
    augroup END
endif
" }}}
" vim: set et sw=4 sts=4 ts=8:
