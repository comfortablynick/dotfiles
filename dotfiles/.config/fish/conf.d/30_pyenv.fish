# Source pyenv scripts
if status is-interactive
and test -n (type -f pyenv 2>/dev/null)
    command pyenv rehash 2>/dev/null
    # source (pyenv init -)
    # source (pyenv virtualenv-init -)
end
