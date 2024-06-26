if set -q _fisher_path_initialized
    exit
end
set -g _fisher_path_initialized

set fisher_path $XDG_DATA_HOME/fisher
if test -z "$fisher_path" -o "$fisher_path" = "$__fish_config_dir"
    exit
end

set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..]
set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..]

for file in $fisher_path/conf.d/*.fish
    if ! test -f (string replace -r "^.*/" $__fish_config_dir/conf.d/ -- $file)
        and test -f $file -a -r $file
        source $file
    end
end
