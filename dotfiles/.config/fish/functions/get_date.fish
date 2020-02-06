# Defined in /tmp/fish.ULRvvL/get_date.fish @ line 2
function get_date --description 'return current date'
    set -l d
    if type -qf date
        echo (date +%s.%N)
    else
        echo (gdate +%s.%N)
    end
end
