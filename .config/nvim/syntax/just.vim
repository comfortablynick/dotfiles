" Justfile syntax with regions of other languages

if exists('b:current_syntax') | finish | endif

syntax keyword  justType            alias
syntax keyword  justConditional     if else

syntax match    justSpecialChar     /\v[^\\]\@/
syntax match    justComment         /#.*$/              display contains=@spell
" syntax match    justVarName         /^\v\w+\s:\=/
syntax match    justVarNameSub      /\v[A-z_]/          contained
" syntax match    justTargetArg       /\v\*[A-z_]+/       contained
" syntax match    justOperator        /\v\=/ contained
" syntax match    justOperator        /\v\+/ contained
syntax match    justOperator        /\v:\=/
" syntax match    justOperator        /\v:$/

" syntax region   justTargetArg       start=+*+ end=+:+he=e-1                             contains=justVarNameSub
syntax region   justTarget          start=/\v^\w/ end=/\v:/he=e-1                       contains=justString,justTargetArg
syntax region   justVarSub          start=+{{+              end=+}}+                    contains=justVarNameSub
syntax region   justString          start=+'+ skip=+\\'+    end=+'+                        keepend
syntax region   justString          start=+"+ skip=+\\"+    end=+"+                      keepend
syntax region   justVarName         start=/\v^\w/           end=/\v\s/                  contains=justOperator

" Enable embedded code in justfile
call syntax#enable_code_snip('sh',     '#!/usr/bin/env bash',    '#\n', 'justEmbedShebang')
call syntax#enable_code_snip('sh',     '#!/usr/bin/env sh',      '#\n', 'justEmbedShebang')
call syntax#enable_code_snip('sh',     '#!/bin/sh',              '#\n', 'justEmbedShebang')
call syntax#enable_code_snip('python', '#!/usr/bin/env python3', '#\n', 'justEmbedShebang')

hi def link     justString          String
hi def link     justTarget          Function
hi def link     justType            Typedef
hi def link     justSpecialChar     Special
hi def link     justComment         Comment
hi def link     justCommand         String
hi def link     justLabel           Keyword
hi def link     justVarSub          Structure
hi def link     justVarName         Identifier
hi def link     justVarNameSub      Constant
hi def link     justOperator        Operator
hi def link     justEmbedShebang    NonText
hi def link     justConditional     Conditional
hi def link     justTargetArg       justSpecialChar

let b:current_syntax = 'just'
