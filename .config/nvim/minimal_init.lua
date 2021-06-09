local api = vim.api

local install_path = "/tmp/site/pack/packer/opt/packer.nvim"

-- vim.o.loadplugins = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " ..
            install_path)
end

vim.opt.runtimepath = {
  "$VIM/vimfiles",
  "$VIMRUNTIME",
  "$VIM/vimfiles/after",
  "/tmp/site",
}
vim.o.packpath = vim.o.runtimepath
vim.opt.completeopt = {"menuone", "noinsert", "noselect"}

_G.p = function(...) print(vim.inspect(...)) end

do
  local opts = {noremap = true}
  api.nvim_set_keymap("n", ";", ":", opts)
  api.nvim_set_keymap("x", ";", ":", opts)
  api.nvim_set_keymap("o", ";", ":", opts)

  api.nvim_set_keymap("n", "g:", ";", opts)
  api.nvim_set_keymap("n", "@;", "@:", opts)
  api.nvim_set_keymap("n", "q;", "q:", opts)
  api.nvim_set_keymap("x", "q;", "q:", opts)

  api.nvim_set_keymap("i", "kj", "<Esc>`^", opts)
end

vim.opt.shortmess:append "c"
vim.cmd[[packadd! packer.nvim]]
vim.cmd[[autocmd BufWritePost minimal_init.lua PackerCompile]]
vim.cmd[[autocmd BufWritePost minimal_init.lua PackerInstall]]

local packer = require"packer"

packer.startup{
  function()
    local use = packer.use
    use{"wbthomason/packer.nvim", opt = true}
    use{"neovim/nvim-lspconfig", requires = {"nvim-lua/completion-nvim"}}
  end,
  config = {package_root = "/tmp/site/pack"},
}

-- vim.cmd"PackerInstall"

-- LSP settings
-- log file location: $HOME/.local/share/nvim/lsp.log
vim.lsp.set_log_level"debug"
local nvim_lsp = require"lspconfig"
local on_attach = function()
  local bufnr = api.nvim_get_current_buf()
  local function buf_set_keymap(...) api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  -- Mappings.
  do
    local opts = {noremap = true, silent = true}
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
                   opts)
    buf_set_keymap("n", "<space>wa",
                   "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wr",
                   "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<space>wl",
                   "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                   opts)
    buf_set_keymap("n", "<space>D",
                   "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "<space>e",
                   "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
                   opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
                   opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
                   opts)
    buf_set_keymap("n", "<space>q",
                   "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  end
end

-- Add the server that troubles you here
local configs = {
  vimls = {initializationOptions = {diagnostic = {enable = true}}},
}

for server, cfg in pairs(configs) do
  cfg.on_attach = on_attach
  nvim_lsp[server].setup(cfg)
end
