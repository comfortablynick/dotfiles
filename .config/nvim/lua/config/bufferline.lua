local installed, bufferline = pcall(require, "bufferline")

if not installed then
  return
end

-- TODO: Make sure this matches latest settings schema
bufferline.setup {
  options = {
    numbers = "none", -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string
    close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
    right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    -- -- name_formatter can be used to change the buffer's label in the bufferline.
    -- -- Please note some names can/will break the
    -- -- bufferline so use this at your discretion knowing that it has
    -- -- some limitations that will *NOT* be fixed.
    -- name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
    --   -- remove extension from markdown files for example
    --   if buf.name:match('%.md') then
    --     return vim.fn.fnamemodify(buf.name, ':t:r')
    --   end
    -- end,
    max_name_length = 30,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 18,
    diagnostics = "nvim_lsp",
    -- Diagnostics indicator function
    -- Accepts args: { count, level, diagnostics_dict, context }
    -- Add the additional args if needed
    diagnostics_indicator = function(count)
      return " (" .. count .. ")"
    end,
    -- -- NOTE: this will be called a lot so don't do any heavy processing here
    -- -- custom_filter = function(buf_number)
    --   -- filter out filetypes you don't want to see
    --   if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
    --     return true
    --   end
    --   -- filter out by buffer name
    --   if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
    --     return true
    --   end
    --   -- filter out based on arbitrary rules
    --   -- e.g. filter out vim wiki buffer from tabline in your work repo
    --   if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
    --     return true
    --   end
    -- end,
    -- offsets = {{filetype = "NvimTree", text = "File Explorer" | function, text_align = "left" | "center" | "right"}},
    show_buffer_icons = true, -- filetype icons for buffers
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- -- Separator style
    -- -- can also be a table containing 2 custom separators
    -- -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = "slant", -- | "thick" | "thin" | { 'any', 'any' },
    -- enforce_regular_tabs = false | true,
    -- always_show_bufferline = true | false,
    -- sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
    --   -- add custom logic
    --   return buffer_a.modified > buffer_b.modified
    -- end
  },
}
