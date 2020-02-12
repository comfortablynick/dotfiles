# WSL startup settings

# Fix umask env variable if WSL didn't set it properly.
if test -f /proc/version && grep -q "Microsoft" /proc/version
  # https://github.com/Microsoft/WSL/issues/352
  if test (umask) -eq "000" && umask "0022"
  end
end
