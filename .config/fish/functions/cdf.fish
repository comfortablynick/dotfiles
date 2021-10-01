function cdf --description 'Fuzzy change directory'
    fd -t d -HL | fzy | read -l select
    test -n "$select"; and builtin cd "$select"
end
