function gv --description 'view current repo using gv.vim'
    nvim +"packadd vim-fugitive" +"packadd gv.vim" +GV +"autocmd BufWipeout <buffer> qall"
end
