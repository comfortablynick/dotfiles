" Use pipx venv if installed
let s:pipx_venv = '~/.local/pipx/venvs/black'

if isdirectory(s:pipx_venv)
    let g:black_virtualenv = s:pipx_venv
endif
