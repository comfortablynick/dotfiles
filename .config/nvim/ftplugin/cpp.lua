vim.b.load_doxygen_syntax = 1
vim.g.quickfix_open = 24

-- Disable function highlighting (affects both C and C++ files)
vim.g.cpp_no_function_highlight = 1

-- Put all standard C and C++ keywords under Vim's highlight group `Statement`
-- (affects both C and C++ files)
vim.g.cpp_simple_highlight = 1

-- Enable highlighting of named requirements (C++20 library concepts)
vim.g.cpp_named_requirements_highlight = 1
