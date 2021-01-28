local api = vim.api

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing message extra message when using completion
vim.cmd[[set shortmess+=c]]

local imap = function(key, result, opts)
  api.nvim_set_keymap("i", key, result, opts or {silent = true})
end

local noop = function() end

local init = function()
  local compe = vim.F.npcall(require, "compe")
  if compe == nil then return end
  -- local complete_exclude_fts = {"clap_input", "qf", ""}
  --
  -- -- Don't load completion
  -- if compe == nil or vim.tbl_contains(complete_exclude_fts, vim.bo.filetype) then
  --   return
  -- end

  require"config.snippets"

  compe.setup{
    enabled = true,
    debug = false,
    min_length = 1,
    preselect = "disable", -- 'enable' || 'disable' || 'always',
    -- throttle_time = ... number ...,
    -- source_timeout = ... number ...,
    -- incomplete_delay = ... number ...,
    allow_prefix_unmatch = false,
    source = {
      path = true,
      buffer = true,
      ultisnips = true,
      nvim_lsp = true,
      nvim_lua = true,
    },
  }

  imap("<C-Space>", "compe#complete()", {expr = true, silent = true})
  if vim.bo.filetype ~= "markdown" then
    imap("<Tab>", "<Cmd>lua nvim.smart_tab()<CR>")
    imap("<S-Tab>", "<Cmd>lua nvim.smart_s_tab()<CR>")
  end
  imap("<CR>", "compe#confirm('<CR>')", {expr = true, silent = true})
  imap("<C-e>", "compe#close('<C-e>')", {expr = true, silent = true})
end

return {init = init}
