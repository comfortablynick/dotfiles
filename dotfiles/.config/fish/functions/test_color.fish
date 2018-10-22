function test_color --description 'Echo test output from supplied color'
	if test -n $argv
set_color $argv[1]; echo "Test output color=$argv[1]"; set_color normal
else
echo "Please supply a color and try again."
end
end
