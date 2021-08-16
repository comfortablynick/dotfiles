function nvim --wraps=vim
    # Open default session if it exists and no args are provided
    if not set -q argv[1]; and test -f Session.vim
        command nvim -S Session.vim
    else
        command nvim $argv
    end
end
