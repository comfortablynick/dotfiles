#!/usr/bin/env fish
function argtest -d "test of argparse"
    set -l options 'u/url=' 'p/path=' 'c/cond=' 'h/help'
    set -l help_txt "argtest help"
    test -z "$argv" && echo "$help_txt" && return 1
    argparse $options -- $argv

    # Process options
    set -q _flag_help && echo "$help_txt" && return 0
    set -q _flag_url && echo $_flag_url
    set -q _flag_path && echo $_flag_path
    set -q _flag_cond && echo $_flag_cond

    if test -n "$argv"
        echo $argv
    end
end
