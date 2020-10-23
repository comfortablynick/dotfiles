" Minimal vimrc
" Use to debug config
scriptencoding utf-8

" vint: -ProhibitSetNoCompatible
set nocompatible
set runtimepath=$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after
let s:pack_path = '~/vim-test'
let &packpath = &runtimepath..','..s:pack_path

" Test lsp config
if 0
    let s:opt_dir = s:pack_path..'/pack/test/opt'
    let s:plugins = [
        \ 'neovim/nvim-lspconfig',
        \ 'nvim-lua/diagnostic-nvim',
        \ ]

    for s:plug in s:plugins
        let s:repo = split(s:plug, '/')[-1]
        let s:dir = s:opt_dir ..'/'.. s:repo
        if !isdirectory(expand(s:dir))
            echo 'Downloading' s:dir
            call system(printf('git clone https://github.com/%s %s', s:plug, s:dir))
        endif
    endfor
    lua <<EOF
    local api = vim.api
    vim.cmd('packadd nvim-lspconfig')
    vim.cmd('packadd diagnostic-nvim')
    local diag_found, diag = pcall(require, "diagnostic")

    local on_attach_cb = function(client, bufnr)
      if diag_found then diag.on_attach() end

      api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
      local map_opts = {noremap = true, silent = true}
      local nmaps = {
        [";d"] = "<Cmd>lua vim.lsp.buf.declaration()<CR>",
        ["gd"] = "<Cmd>lua vim.lsp.buf.definition()<CR>",
        ["gh"] = "<Cmd>lua vim.lsp.buf.hover()<CR>",
        ["gi"] = "<Cmd>lua vim.lsp.buf.implementation()<CR>",
        [";s"] = "<Cmd>lua vim.lsp.buf.signature_help()<CR>",
        [";a"] = "<Cmd>lua vim.lsp.buf.code_action()<CR>",
        ["gt"] = "<Cmd>lua vim.lsp.buf.type_definition()<CR>",
        ["gr"] = "<Cmd>lua vim.lsp.buf.references()<CR>",
        ["gld"] = "<Cmd>lua vim.lsp.util.show_line_diagnostics()<CR>",
        ["<F2>"] = "<Cmd>lua vim.lsp.buf.rename()<CR>",
      }

      for lhs, rhs in pairs(nmaps) do
        api.nvim_buf_set_keymap(bufnr, "n", lhs, rhs, map_opts)
      end
    end

    require'nvim_lsp'.sumneko_lua.setup{on_attach = on_attach_cb}
    require'nvim_lsp'.vimls.setup{on_attach = on_attach_cb}
    require'nvim_lsp'.diagnosticls.setup{
          on_attach = on_attach_cb,
          filetypes = {"lua", "vim", "sh", "python"},
          init_options = {
            filetypes = {vim = "vint", sh = "shellcheck", python = "pydocstyle"},
            linters = {
              vint = {
                command = "vint",
                debounce = 100,
                args = {"--enable-neovim", "-"},
                offsetLine = 0,
                offsetColumn = 0,
                sourceName = "vint",
                formatLines = 1,
                formatPattern = {
                  "[^:]+:(\\d+):(\\d+):\\s*(.*)(\\r|\\n)*$",
                  {line = 1, column = 2, message = 3},
                },
              },
            },
          },
        }
EOF
end

filetype plugin indent on
syntax enable
