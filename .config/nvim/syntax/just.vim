" Justfile syntax with regions of other languages

if exists('b:current_syntax') | finish | endif

syntax keyword  justType            alias

syntax match    specialChar         '\v[^\\]\@'
syntax match    justComment         '#.*$'              display contains=@spell
syntax match    justVarName         '\v[A-Z_]'
syntax match    justVarNameSub      '\v[A-z_]'          contained
syntax match    justOperator        '\v:\='
syntax match    justOperator        '\v\='
syntax match    justOperator        '\v\+'

syntax region   justTarget          start='\v^[A-Za-z]' skip='\v\+\=' end='\v:'he=e-1   contains=justString
syntax region   justVarSub          start='{{' end='}}'                                 contains=justVarNameSub
syntax region   justString          start=+'+ skip=+\\'+ end=+'+                        keepend
syntax region   justString          start=+"+ skip=+\\"+ end=+"+                        keepend

" Enable embedded code in justfile
call syntax#enable_code_snip('sh',     '#!/usr/bin/env bash',    '#\n', 'justEmbedShebang')
call syntax#enable_code_snip('sh',     '#!/usr/bin/env sh',      '#\n', 'justEmbedShebang')
call syntax#enable_code_snip('sh',     '#!/bin/sh',              '#\n', 'justEmbedShebang')
call syntax#enable_code_snip('python', '#!/usr/bin/env python3', '#\n', 'justEmbedShebang')

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
hi def link     justString          String
hi def link     justTarget          Keyword
hi def link     justType            Typedef
hi def link     specialChar         Special
hi def link     justComment         Comment
hi def link     justCommand         String
hi def link     justLabel           Keyword
hi def link     justVarSub          Structure
hi def link     justVarName         Identifier
hi def link     justVarNameSub      Constant
hi def link     justOperator        Operator
hi def link     justEmbedShebang    NonText

let b:current_syntax = 'just'
