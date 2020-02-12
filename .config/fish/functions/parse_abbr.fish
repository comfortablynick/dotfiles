# Defined in /tmp/fish.2gfYIy/parse_abbr.fish @ line 2
function parse_abbr --description 'parse output of abbr -s'
	for f in $full
        set -l abv (string split ' ' (string split ' -- ' $f)[2])
        echo $abv[1]: $abv[2..-1]
    end
end
