scriptencoding utf-8

if exists('g:loaded_ale_config_vim')
    finish
endif
let g:loaded_ale_config_vim = 1

" Main options
let g:ale_close_preview_on_insert = 1                           " Close preview window in INSERT mode
let g:ale_cursor_detail = 0                                     " Open preview window when focusing on error
let g:ale_echo_cursor = 1                                       " Either this or ale_cursor_detail need to be set to 1
let g:ale_cache_executable_check_failures = 1                   " Have to restart vim if adding new providers
let g:ale_lint_on_text_changed = 'never'                        " Don't lint while typing (too distracting)
let g:ale_lint_on_insert_leave = 1                              " Lint after leaving insert
let g:ale_lint_on_enter = 0                                     " Lint when opening file
let g:ale_list_window_size = 5                                  " Show # of lines of errors
let g:ale_open_list = 0                                         " Show quickfix list
let g:ale_set_loclist = 0                                       " Show location list
let g:ale_set_quickfix = 1                                      " Show quickfix list with errors
let g:ale_fix_on_save = 1                                       " Apply fixes when saving
let g:ale_echo_msg_error_str = 'E'                              " Error string prefix
let g:ale_echo_msg_warning_str = 'W'                            " Warning string prefix
let g:ale_echo_msg_format = '[%linter%] %s (%severity%%: code%)'
let g:ale_sign_column_always = 0                                " Always show column on left side, even with no errors/warnings
let g:ale_completion_enabled = 0                                " Enable ALE completion if no other completion engines
let g:ale_virtualtext_cursor = 1                                " Enable Neovim's virtualtext support
let g:ale_virtualtext_prefix = ' ➜ '                           " Prefix the virtualtext message
let g:ale_virtualenv_dir_names = ['.env', 'dev']

" Linters/fixers
let g:ale_linters = {
    \ 'python': [],
    \ 'cpp': [],
    \ 'c': ['clangtidy','gcc'],
    \ 'lua': [],
    \ 'go': ['golint'],
    \ 'rust': [],
    \ 'sh': ['shellcheck'],
    \ 'typescript': [],
    \ 'yaml.ansible': ['ansible-lint'],
    \ }

let g:ale_fixers = {
    \ '*': ['remove_trailing_lines','trim_whitespace'],
    \ 'python': ['black','isort'],
    \ 'typescript': ['prettier'],
    \ 'javascript': ['prettier'],
    \ 'go': ['goimports'],
    \ 'sh': ['shfmt'],
    \ 'zsh': ['shfmt'],
    \ 'cpp': ['clang-format'],
    \ 'c': ['clang-format'],
    \ 'rust': ['rustfmt'],
    \ 'cmake': ['cmakeformat'],
    \ }

" Linter/fixer options
let g:ale_python_flake8_options = '--max-line-length 100  --ignore E203,E302,W503'
let g:ale_python_mypy_ignore_invalid_syntax = 1
let g:ale_python_mypy_options = '--ignore-missing-imports'
let g:ale_python_auto_pipenv = 1
let g:ale_javascript_prettier_options = '--trailing-comma all --tab-width 4 --endOfLine lf'
let g:ale_typescript_prettier_options = g:ale_javascript_prettier_options
let g:ale_go_gometalinter_options = '--fast --aggregate --cyclo-over=20'
let g:ale_rust_rls_toolchain = 'stable'
let g:ale_c_gcc_options = '-std=gnu11 -Wall -Wextra'
let g:ale_cmake_cmakeformat_options = '--config-file $HOME/.config/cmake/cmake-format.py'
let g:ale_cmake_cmakelint_options = '--config=$HOME/.config/cmake/cmakelintrc'

" Maps
nmap <silent> <Leader>f <Plug>(ale_next_wrap)
nmap <silent> <Leader>g <Plug>(ale_previous_wrap)

" Paste from register
nnoremap <Leader>0 "0p<CR>
nnoremap <Leader>1 "1p<CR>
nnoremap <Leader>2 "2p<CR>
nnoremap <Leader>3 "3p<CR>
nnoremap <Leader>4 "4p<CR>
