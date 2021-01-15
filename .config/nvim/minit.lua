local api = vim.api
local test_packpath = "/tmp/nvim-pack/site"
local install_path = test_packpath .. "/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " ..
            install_path)
end

vim.o.runtimepath =
  "$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,/tmp/nvim-test"
vim.o.packpath = vim.o.runtimepath .. "," .. test_packpath
vim.o.completeopt = "menuone,noinsert,noselect"
vim.cmd[[set shortmess+=c]]
vim.cmd[[set omnifunc=v:lua.vim.lsp.omnifunc]]

-- Keymaps
-- api.nvim_set_keymap()

p = function(...) print(vim.inspect(...)) end -- luacheck: ignore 131

require"packer".startup{
  function(use)
    use{"wbthomason/packer.nvim"}
    use{
      "norcalli/snippets.nvim",
      config = function()
        local snippets = require"snippets"
        snippets.use_suggested_mappings()
      end,
    }
    use{"neovim/nvim-lspconfig", requires = {{"nvim-lua/completion-nvim"}}}
  end,
  config = {
    package_root = "/tmp/nvim-pack/site/pack",
    compile_path = "/tmp/nvim-test/plugin/packer_compiled.vim",
  },
}

local lspconfig = require"lspconfig"
local completion = require"completion"

local chain_complete_list = {
  default = {
    {complete_items = {'lsp', 'snippet'}},
    {complete_items = {'path'}, triggered_only = {'/'}},
    -- {complete_items = {'buffers'}},
  },
  string = {
    {complete_items = {'path'}, triggered_only = {'/'}},
  },
  comment = {},
}

local on_attach_cb = function()
  completion.on_attach{
    enable_auto_paren = 0,
    enable_auto_hover = 1,
    enable_auto_signature = 1,
    auto_change_source = 1,
    enable_snippet = "snippets.nvim",
    chain_complete_list = chain_complete_list,
  }

end

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Test configs
lspconfig.sumneko_lua.setup{on_attach = on_attach_cb}
lspconfig.vimls.setup{on_attach = on_attach_cb}
