# Jump to directory
function __jump_hint
    set -l term (string replace -r '^j ' '' -- (commandline -cp))
    jump hint $term
end

complete --command j --exclusive --arguments '(__jump_hint)'
