complete -c dropbox -n __fish_use_subcommand -f -a status -d "Get current status of the dropboxd"
complete -c dropbox -n __fish_use_subcommand -f -a help -d "Provide help"
complete -c dropbox -n __fish_use_subcommand -f -a running -d "Return 1 if dropbox is running"
complete -c dropbox -n __fish_use_subcommand -f -a autostart -d "Ubuntu: automatically start dropbox at login"
complete -c dropbox -n "__fish_use_subcommand; and dropbox running" -f -a start -d "Start dropboxd"
complete -c dropbox -n "__fish_use_subcommand; and not dropbox running" -f -a puburl -d "Get public url of a file in your dropbox"
complete -c dropbox -n "__fish_use_subcommand; and not dropbox running" -f -a stop -d "Stop dropboxd"
complete -c dropbox -n "__fish_use_subcommand; and not dropbox running" -f -a 'stat filestatus' -d "Get current sync status of one or more files"
complete -c dropbox -n "__fish_use_subcommand; and not dropbox running" -f -a ls -d "List directory contents with current sync status"
complete -c dropbox -n "__fish_use_subcommand; and not dropbox running" -f -a exclude -d "Ignores/excludes a directory from syncing"
complete -c dropbox -n "__fish_use_subcommand; and not dropbox running" -f -a lansync -d "Enables or disables LAN sync"

set -l subcommands help puburl stop running start file status ls autostart exclude lansync stat
complete -c dropbox -n "__fish_seen_subcommand_from help" -x -a "$subcommands"
complete -c dropbox -n "__fish_seen_subcommand_from start" -s i -l install -d "Auto install dropboxd if not available on the system"
complete -c dropbox -n "__fish_seen_subcommand_from filestatus stat" -s l -l list -d "Prints out information in a format similar to ls. works best when your console supports color :)"
complete -c dropbox -n "__fish_seen_subcommand_from filestatus stat ls" -s a -l all -d "Do not ignore entries starting with ."
complete -c dropbox -n "__fish_seen_subcommand_from autostart lansync" -x -a '(echo -e "y\tEnable\nn\tDisable")'

set -l needs_excl_arg "__fish_seen_subcommand_from exclude; and not __fish_seen_subcommand_from list add remove"
complete -c dropbox -n $needs_excl_arg -f -a list -d "Prints a list of directories currently excluded from syncing"
complete -c dropbox -n $needs_excl_arg -r -a add -d "Adds one or more directories to the exclusion list"
complete -c dropbox -n $needs_excl_arg -r -a remove -d "Removes one or more directories from the exclusion list"
complete -c dropbox -n "__fish_seen_subcommand_from exclude; and __fish_seen_subcommand_from remove" -x -a '(dropbox exclude list | sed -e "1d")'
complete -c dropbox -n "__fish_seen_subcommand_from exclude; and __fish_seen_subcommand_from add" -r -a '(set -l CDPATH; __fish_complete_cd)'
