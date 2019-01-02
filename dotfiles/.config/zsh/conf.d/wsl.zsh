# WSL (Windows Subsystem for Linux) Fixes

if [ -f /proc/version ] && grep -q "Microsoft" /proc/version; then

# Fix umask value if WSL didn't set it properly.
# https://github.com/Microsoft/WSL/issues/352
[ "$(umask)" = "000" ] && umask 022

# Don't change priority of background processes with nice.
# https://github.com/Microsoft/WSL/issues/1887
unsetopt BG_NICE

fi
