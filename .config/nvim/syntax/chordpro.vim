" ====================================================
" Filename:    syntax/chordpro.vim
" Description: Syntax file for chordpro
" Author:      Nick Murphy (comfortablynick@gmail.com) 
" (Original by Niels Bo Andersen <niels@niboan.dk>)
" License:     MIT
" ====================================================
syn case ignore

syn keyword ProDirective start_of_chorus soc end_of_chorus eoc new_song ns contained
syn keyword ProDirective base-fret frets no_grid ng grid g new_page np contained
syn keyword ProDirective new_physical_page npp start_of_tab sot contained
syn keyword ProDirective end_of_tab eot column_break colb contained

syn keyword ProDirWithOpt comment c comment_italic ci comment_box cb contained
syn keyword ProDirWithOpt title t subtitle st define contained
syn keyword ProDirWithOpt textfont textsize chordfont chordsize contained
syn keyword ProDirWithOpt columns col contained

syn region ProTag matchgroup=ProBracket start=+{+ end=+}+ contains=ProDirective keepend oneline
syn region ProTag matchgroup=ProBracket start=+{+ end=+:.\{-}}+ contains=ProDirWithOpt keepend oneline
syn region ProChord matchgroup=ProBracket start=+\[+ end=+]+ keepend oneline

syn match ProComment "#.*"

" Define the default highlighting.
hi def link ProDirective Statement
hi def link ProDirWithOpt Statement
hi def link ProChord Type
hi def link ProTag Special
hi def link ProComment Comment
hi def link ProBracket Constant

let b:current_syntax = 'chordpro'
