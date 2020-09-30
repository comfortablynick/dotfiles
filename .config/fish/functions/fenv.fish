# Defined in /tmp/fish.27y1eg/fenv.fish @ line 2
function fenv --description 'fuzzy search shell env'
    # set -l cmd "env -0 | fzf --read0"
    # if test -n "$argv"
    #     set -a cmd "--prompt $argv"
    # end
    env -0 | fzf --read0 --prompt='ENV:> ' --query="$argv"
end
