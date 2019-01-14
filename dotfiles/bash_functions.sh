#!/usr/bin/env bash
# Helpful bash scripts; loaded by .bashrc
# For: funcs available at all times (not loaded in $PATH)

# Reset the terminal and source .bashrc
reload() {
    reset
    export DEBUG_MODE=false
    source ${HOME}/.bashrc
}

# Reset and print elapsed time for debugging
brel() {
    reset
    if [ "$1" == "d" ]; then
        export DEBUG_MODE=true
    else
        export DEBUG_MODE=false
    fi
    time . "${HOME}/.bashrc"
}

# Easily print timestamp
timestamp() {
    date +"%T"
}

_pyenv_virtualenv_hook() {
    local ret=$?
    if [ -n "$VIRTUAL_ENV" ]; then
        eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
    else
        eval "$(pyenv sh-activate --quiet || true)" || true
    fi
    return $ret
}
if ! [[ "$PROMPT_COMMAND" =~ _pyenv_virtualenv_hook ]]; then
    PROMPT_COMMAND="_pyenv_virtualenv_hook;$PROMPT_COMMAND"
fi

pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  activate|deactivate|rehash|shell)
    eval "$(pyenv "sh-$command" "$@")";;
  *)
    command pyenv "$command" "$@";;
  esac
}

