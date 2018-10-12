function fix_wsl_umask --description 'For WSL: fix incorrect default permissions on directories'
	if test -f /proc/version && grep -q "Microsoft" /proc/version
# Fix umask value if WSL didn't set it properly.
# https://github.com/Microsoft/WSL/issues/352
if test (umask) -eq "000" && umask 022
end
end
end
