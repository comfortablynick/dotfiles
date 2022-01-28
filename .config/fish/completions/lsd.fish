complete -c lsd -n "__fish_use_subcommand" -l color -d 'When to use terminal colours' -r -f -a "always auto never"
complete -c lsd -n "__fish_use_subcommand" -l icon -d 'When to print the icons' -r -f -a "always auto never"
complete -c lsd -n "__fish_use_subcommand" -l icon-theme -d 'Whether to use fancy or unicode icons' -r -f -a "fancy unicode"
complete -c lsd -n "__fish_use_subcommand" -l config-file -d 'Provide a custom lsd configuration file'
complete -c lsd -n "__fish_use_subcommand" -l depth -d 'Stop recursing into directories after reaching specified depth'
complete -c lsd -n "__fish_use_subcommand" -l size -d 'How to display size' -r -f -a "default short bytes"
complete -c lsd -n "__fish_use_subcommand" -l date -d 'How to display date [possible values: date, relative, +date-time-format]'
complete -c lsd -n "__fish_use_subcommand" -l sort -d 'sort by WORD instead of name' -r -f -a "size time version extension"
complete -c lsd -n "__fish_use_subcommand" -l group-dirs -d 'Sort the directories then the files' -r -f -a "none first last"
complete -c lsd -n "__fish_use_subcommand" -l blocks -d 'Specify the blocks that will be displayed and in what order' -r -f -a "permission user group size date name inode links"
complete -c lsd -n "__fish_use_subcommand" -s I -l ignore-glob -d 'Do not display files/directories with names matching the glob pattern(s). More than one can be specified by repeating the argument'
complete -c lsd -n "__fish_use_subcommand" -s a -l all -d 'Do not ignore entries starting with .'
complete -c lsd -n "__fish_use_subcommand" -s A -l almost-all -d 'Do not list implied . and ..'
complete -c lsd -n "__fish_use_subcommand" -s F -l classify -d 'Append indicator (one of */=>@|) at the end of the file names'
complete -c lsd -n "__fish_use_subcommand" -s l -l long -d 'Display extended file metadata as a table'
complete -c lsd -n "__fish_use_subcommand" -l ignore-config -d 'Ignore the configuration file'
complete -c lsd -n "__fish_use_subcommand" -s 1 -l oneline -d 'Display one entry per line'
complete -c lsd -n "__fish_use_subcommand" -s R -l recursive -d 'Recurse into directories'
complete -c lsd -n "__fish_use_subcommand" -s h -l human-readable -d 'For ls compatibility purposes ONLY, currently set by default'
complete -c lsd -n "__fish_use_subcommand" -l tree -d 'Recurse into directories and present the result as a tree'
complete -c lsd -n "__fish_use_subcommand" -s d -l directory-only -d 'Display directories themselves, and not their contents (recursively when used with --tree)'
complete -c lsd -n "__fish_use_subcommand" -l total-size -d 'Display the total size of directories'
complete -c lsd -n "__fish_use_subcommand" -s t -l timesort -d 'Sort by time modified'
complete -c lsd -n "__fish_use_subcommand" -s S -l sizesort -d 'Sort by size'
complete -c lsd -n "__fish_use_subcommand" -s X -l extensionsort -d 'Sort by file extension'
complete -c lsd -n "__fish_use_subcommand" -s v -l versionsort -d 'Natural sort of (version) numbers within text'
complete -c lsd -n "__fish_use_subcommand" -s r -l reverse -d 'Reverse the order of the sort'
complete -c lsd -n "__fish_use_subcommand" -l classic -d 'Enable classic mode (display output similar to ls)'
complete -c lsd -n "__fish_use_subcommand" -l no-symlink -d 'Do not display symlink target'
complete -c lsd -n "__fish_use_subcommand" -s i -l inode -d 'Display the index number of each file'
complete -c lsd -n "__fish_use_subcommand" -s L -l dereference -d 'When showing file information for a symbolic link, show information for the file the link references rather than for the link itself'
complete -c lsd -n "__fish_use_subcommand" -l help -d 'Prints help information'
complete -c lsd -n "__fish_use_subcommand" -s V -l version -d 'Prints version information'
