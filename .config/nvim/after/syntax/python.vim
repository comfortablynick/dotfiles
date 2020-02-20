scriptencoding=utf-8

if !get(g:, 'python_conceal', 0) || !has('conceal') || &encoding !=# 'utf-8'
    finish
endif

silent! syntax clear pythonOperator

syntax match Normal '->' conceal cchar=→
syntax match Normal '<=' conceal cchar=≤
syntax match Normal '>=' conceal cchar=≥


syntax keyword Normal lambda conceal cchar=λ

highlight! link pyBuiltin pyOperator
highlight! link pyOperator Operator
highlight! link pyStatement Statement
highlight! link pyKeyword Keyword
highlight! link pyComment Comment
highlight! link pyConstant Constant
highlight! link pySpecial Special
highlight! link pyIdentifier Identifier
highlight! link pyType Type
