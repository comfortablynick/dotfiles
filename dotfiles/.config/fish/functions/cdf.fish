# Defined in /tmp/fish.xyyiSF/cdf.fish @ line 2
function cdf --description 'Fuzzy change directory'
	

    # eval "$cmd | fzy" | read -l select
    fd -t d -HL | fzy | read -l select
    test -n "$select"; and builtin cd "$select"
end
