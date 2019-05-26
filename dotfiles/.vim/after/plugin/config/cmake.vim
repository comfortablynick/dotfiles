if exists('g:loaded_cmake_config_vim') || exists(':CMake')
    finish
endif
let g:loaded_cmake_config_vim = 1

let g:cmake_ycm_symlinks = 0                                    " Symlink json file for YouCompleteMe
