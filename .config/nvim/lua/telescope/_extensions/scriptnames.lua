local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require "telescope.config".values

local function get_scriptnames()
  local scripts = vim.api.nvim_cmd({ cmd = "scriptnames" }, { output = true })
  local lines = vim.split(scripts, "\r?\n")
  return lines
end

local function show_scriptnames(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = "Scriptnames",
      finder = finders.new_table {
        results = get_scriptnames(),
        entry_maker = function(entry)
          local fname = entry:gsub("%s*%d+:%s", "")
          return {
            value = entry,
            ordinal = entry,
            display = entry,
            filename = fname,
          }
        end,
      },
      sorter = conf.file_sorter(opts),
      previewer = conf.file_previewer(opts),
    })
    :find()
end

return require("telescope").register_extension {
  exports = {
    scriptnames = show_scriptnames,
  },
}
