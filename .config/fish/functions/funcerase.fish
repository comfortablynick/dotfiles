# Defined in /tmp/fish.nTnr9j/funcerase.fish @ line 2
function funcerase --description 'erase function from shell and delete file in user functions dir'
    set -l name (string replace .fish '' $argv[1])

    if functions -q $name
        functions -e $name
        echo "Function $name erased from shell"
    end

    set -l file "$__fish_config_dir/functions/$name.fish"

    if test -f $file
        rm $file
        and echo "$file deleted from disk."
    else
        echo "No file $name.fish found in functions directory."
    end
end
