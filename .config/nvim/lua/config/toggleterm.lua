local installed, toggleterm = pcall(require, "toggleterm")

if not installed then
  return
end

local ui = vim.api.nvim_list_uis()[1]

-- nvim-toggleterm trial to see about replacing floaterm
toggleterm.setup {
  size = function(term)
    if term.direction == "horizontal" then
      return ui.height * 0.2
    elseif term.direction == "vertical" then
      return ui.width * 0.3
    end
  end,
  open_mapping = [[<F8>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = "1", -- the degree by which to darken to terminal, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = "float",
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.g.term_shell,
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_win_open'
    -- see :h nvim_win_open for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = "curved",
    width = function()
      return math.floor(ui.width * 0.5)
    end,
    height = function()
      return math.floor(ui.height * 0.5)
    end,
    winblend = 20,
    highlights = { border = "Pmenu", background = "Normal" },
  },
}
