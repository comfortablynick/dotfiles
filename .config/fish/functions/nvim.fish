function nvim --wraps=vim
    # Open default session if it exists and no args are provided
    # packadd vim-obsession (should fail silently if not installed)
    if not set -q argv[1]; and test -f Session.vim
        command nvim -S Session.vim +"packadd vim-obsession"
    else
        command nvim $argv
    end
end
