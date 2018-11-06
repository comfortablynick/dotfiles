# Defined in /tmp/fish.40g0E4/parse_plug.fish @ line 2
function parse_plug --description 'parse fundle plugin call'
	set -l plug "account/repo '{from: gh, if: test 1 -eq 1, after: ./install.py}'"
    echo "Input: $plug"
    set -l commands (echo $plug |grep -Po '{\K[^{]*(?=})')
    echo "Commands: $commands"
end
