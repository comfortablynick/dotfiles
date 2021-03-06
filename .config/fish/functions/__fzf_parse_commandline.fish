# Defined in /var/folders/09/rfyz42rn67z2lg9jnw0gs9240000gn/T//fish.C9zVYy/__fzf_parse_commandline.fish @ line 2
function __fzf_parse_commandline --description 'Parse the current command line token and return split of existing filepath and rest of token'
    # eval is used to do shell expansion on paths
    set -l commandline (eval "printf '%s' "(commandline -t))

    if [ -z $commandline ]
      # Default to current directory with no --query
      set dir '.'
      set fzf_query ''
    else
      set dir (__fzf_get_dir $commandline)

      if [ "$dir" = "." -a (string sub -l 1 $commandline) != '.' ]
        # if $dir is "." but commandline is not a relative path, this means no file path found
        set fzf_query $commandline
      else
        # Also remove trailing slash after dir, to "split" input properly
        set fzf_query (string replace -r "^$dir/?" '' "$commandline")
      end
    end

    echo $dir
    echo $fzf_query
  
end
