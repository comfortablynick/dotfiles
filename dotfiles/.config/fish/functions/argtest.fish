# Defined in /var/folders/gb/x1313fbd2klb5mss86_gsd1m0000gn/T//fish.xqmcm4/argtest.fish @ line 2
function argtest --description 'test of argparse'
    set -l help_txt "argtest help"
    test -z "$argv" && echo "$help_txt" && return 1

    # Process options


    # if eval $_flag_cond
    if echo "$_flag_cond" | source
        echo "Cond true"
    else
        echo "Cond false"
    end

    if test -n "$argv"
        echo $argv
    end

    switch $argv
        case -l {,--}list
            echo "list"
        case "*"
            echo "other: $argv"
    end
end
