local ok, ts_utils = pcall(require, "nvim-lsp-ts-utils")

return function(on_attach)
  if not ok then
    return { on_attach = on_attach }
  end
  return {
    init_options = ts_utils.init_options,
    on_attach = function(client, bufnr)
      -- Disable tsserver formatting to avoid prompts
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false

      -- defaults
      ts_utils.setup {
        debug = false,
        disable_commands = false,
        enable_import_on_completion = false,

        -- import all
        import_all_timeout = 5000, -- ms
        -- lower numbers indicate higher priority
        import_all_priorities = {
          same_file = 1, -- add to existing import statement
          local_files = 2, -- git files or files with relative path markers
          buffer_content = 3, -- loaded buffer content
          buffers = 4, -- loaded buffer names
        },
        import_all_scan_buffers = 100,
        import_all_select_source = false,

        -- eslint
        eslint_enable_code_actions = true,
        eslint_enable_disable_comments = true,
        eslint_bin = "eslint",
        eslint_enable_diagnostics = true,
        eslint_opts = {},

        -- formatting
        enable_formatting = true,
        formatter = "prettier",
        formatter_opts = {},

        -- update imports on file move
        update_imports_on_move = false,
        require_confirmation_on_move = false,
        watch_dir = nil,

        -- filter diagnostics
        filter_out_diagnostics_by_severity = {},
        filter_out_diagnostics_by_code = { 6133 },

        -- inlay hints
        auto_inlay_hints = true,
        inlay_hints_highlight = "Comment",
      }

      -- required to fix code action ranges and filter diagnostics
      ts_utils.setup_client(client)

      on_attach(client, bufnr)
    end,
  }
end
