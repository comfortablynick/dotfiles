# jump hook

function __jump_add --on-variable PWD
    status --is-command-substitution
    and return
    jump chdir
end
