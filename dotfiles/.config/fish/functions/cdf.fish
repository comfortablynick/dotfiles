function cdf -d "Fuzzy change directory"
    set -l cmd "command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
-o -type d -print 2> /dev/null | sort | cut -b3-"

    eval "$cmd | fzy" | read -l select

    if not test -z "$select"
        builtin cd "$select"
    end
end
