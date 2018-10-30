# Defined in /tmp/fish.UMPSCC/get_date.fish @ line 2
function get_date --description 'return current date'
	set -l d (date +%s.%N)
if echo $d | grep -v 'N' > /dev/null 2>&1
echo $d
else
gdate +%s.%N
end
return 0
end
