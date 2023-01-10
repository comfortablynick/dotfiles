-- General autocmds
local api = vim.api
local map = vim.keymap
local aug = api.nvim_create_augroup("init_lua", { clear = true })

api.nvim_create_autocmd("BufReadPost", { -- :: Go to last loc when opening a buffer
  group = aug,
  callback = function()
    local ignore_filetypes = { "gitcommit", "gitrebase", "svn", "hgcommit" }
    local ignore_buftypes = { "quickfix", "nofile", "help" }

    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) or vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
      return
    end

    local mark = api.nvim_buf_get_mark(0, '"')
    local lcount = api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

api.nvim_create_autocmd("CmdwinEnter", { -- :: Custom Cmdwin settings
  group = aug,
  desc = "Custom cmdwin settings",
  callback = function()
    for _, lhs in ipairs { "<Leader>q", "<Esc>", "cq" } do
      map.set("n", lhs, "<C-c><C-c>", { buffer = true })
    end

    vim.wo.number = true
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
  end,
})

api.nvim_create_autocmd("ColorScheme", { -- :: Set custom highlights
  group = aug,
  desc = "Set custom highlights",
  callback = function()
    require("config.lsp").set_hl()
    statusline.set_hl()
  end,
})

api.nvim_create_autocmd("TermOpen", { -- :: Set options for terminal windows
  group = aug,
  desc = "Set options for terminal windows",
  callback = function()
    -- vim.cmd "startinsert"
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.bo.buflisted = false
  end,
})

api.nvim_create_autocmd("TextYankPost", { -- :: Highlight yanked test
  group = aug,
  desc = "Highlight yanked text",
  callback = function()
    -- Looks best with color attribute gui=reverse
    vim.highlight.on_yank { higroup = "TermCursor", timeout = 750 }
  end,
})

api.nvim_create_autocmd( -- :: Autoclose unneeded buffers
  "QuitPre",
  { group = aug, desc = "Autoclose unneeded buffers", command = "silent call buffer#autoclose()" }
)

if vim.wo.cursorline then
  api.nvim_create_autocmd({ "FocusGained", "BufEnter", "WinEnter", "InsertLeave" }, {
    group = aug,
    desc = "Toggle cursorline if window in focus",
    callback = function()
      vim.wo.cursorline = true
    end,
  })
  api.nvim_create_autocmd({ "FocusLost", "BufLeave", "WinLeave", "InsertEnter" }, {
    group = aug,
    desc = "Toggle cursorline if window not in focus",
    callback = function()
      vim.wo.cursorline = false
    end,
  })
end

if vim.wo.relativenumber then
  api.nvim_create_autocmd({ "FocusGained", "WinEnter", "BufEnter", "InsertLeave" }, {
    group = aug,
    desc = "Toggle relativenumber if window in focus",
    callback = function()
      if vim.wo.number and vim.bo.buftype == "" and not vim.b.no_toggle_line_numbers then
        vim.wo.relativenumber = true
      end
    end,
  })
  api.nvim_create_autocmd({ "FocusLost", "WinLeave", "BufLeave", "InsertEnter" }, {
    group = aug,
    desc = "Toggle relativenumber if window not in focus",
    callback = function()
      if vim.wo.number and vim.bo.buftype == "" and not vim.b.no_toggle_line_numbers then
        vim.wo.relativenumber = false
      end
    end,
  })
end
