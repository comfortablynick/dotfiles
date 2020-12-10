" Minimal vimrc
" Use to debug config
scriptencoding utf-8

" vint: -ProhibitSetNoCompatible
set nocompatible
set runtimepath=$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/vim-test
let s:pack_path = '~/vim-test'
let &packpath = &runtimepath..','..s:pack_path

" luafile $XDG_CONFIG_HOME/nvim/lua/config/completion/init.lua

" Test lsp config
if 1
    let s:opt_dir = s:pack_path..'/pack/test/opt'
    let s:plugins = [
        \ 'neovim/nvim-lspconfig',
        \ 'nvim-lua/completion-nvim',
        \ ]

    for s:plug in s:plugins
        let s:repo = split(s:plug, '/')[-1]
        let s:dir = s:opt_dir ..'/'.. s:repo
        if !isdirectory(expand(s:dir))
            echo 'Downloading' s:dir
            call system(printf('git clone https://github.com/%s %s', s:plug, s:dir))
        endif
    endfor

    augroup minirc
        autocmd!
        autocmd BufEnter * lua require'config.completion'
    augroup END

    imap <Tab>   <Plug>(completion_smart_tab)
    imap <S-Tab> <Plug>(completion_smart_s_tab)

    set completeopt=menuone,noinsert,noselect
    set shortmess+=c

    let g:completion_enable_auto_paren = 1
    let g:completion_enable_auto_hover = 1
    let g:completion_enable_auto_signature = 1
    let g:completion_auto_change_source = 1

    lua <<EOF
    local api = vim.api
    vim.cmd[[packadd nvim-lspconfig]]
    vim.cmd[[packadd completion-nvim]]

    local on_attach_cb = function(client)
      require'completion'.on_attach()
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
        api.nvim_buf_set_keymap(0, "n", lhs, rhs, map_opts)
      end
    end

    require'lspconfig'.sumneko_lua.setup{on_attach = on_attach_cb}
    require'lspconfig'.vimls.setup{on_attach = on_attach_cb}
    require'lspconfig'.diagnosticls.setup{
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
