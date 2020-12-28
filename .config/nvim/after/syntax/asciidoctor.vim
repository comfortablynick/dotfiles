if get(g:, 'asciidoctor_syntax_conceal', 0)
    syn region asciiDoctorCaption matchgroup=capDelim start=+^\.+ end=+$+ contains=@asciidoctorInline,@Spell concealends
    hi link capDelim asciiDoctorCaption
endif
