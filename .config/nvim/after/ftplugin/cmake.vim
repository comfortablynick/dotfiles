setlocal shiftwidth=2 tabstop=2
setlocal makeprg=cmakelint\ --config=$XDG_CONFIG_HOME/cmake/cmakelintrc\ %
setlocal formatprg=cmake-format\ -c\ $XDG_CONFIG_HOME/cmake/cmake-format.py\ %
setlocal foldmethod=marker

let b:neoformat_run_all_formatters = 0
