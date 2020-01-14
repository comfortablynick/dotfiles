-- From: https://gist.github.com/norcalli/2a0bc2ab13c12d7c64efc7cdacbb9a4d
local vim = vim
local M = {}

local function open_floating_terminal(command)
    local uis = vim.api.nvim_list_uis()
    local opts = {
        relative = "editor",
        width = math.floor(uis[1].width * 50 / 100),
        height = math.floor(uis[1].height * 50 / 100),
        anchor = "NW",
        style = "minimal",
        focusable = false,
    }
    opts.col = math.floor((uis[1].width - opts.width) / 2)
    opts.row = math.floor((uis[1].height - opts.height) / 2)
    local bufnr = vim.api.nvim_create_buf(false, true)
    local winnr = vim.api.nvim_open_win(bufnr, true, opts)

    vim.api.nvim_call_function("termopen", {command})
    return bufnr, winnr
end

-- Designed to run a buffer with vim commands on each line.
-- Not that useful to me, but keep the code for future reuse.
local function run_script(lines, start, starting_winnr)
    starting_winnr = starting_winnr or vim.api.nvim_get_current_win()
    for i = (start or 1), #lines do
        local line = lines[i]
        if line:match("^:!") then
            local command = line:sub(3)
            local bufnr, _ = open_floating_terminal(command)
            vim.api.nvim_command("startinsert!")
            vim.api.nvim_buf_attach(
                bufnr, false, {
                    on_detach = vim.schedule_wrap(
                        function()
                            run_script(lines, i + 1, starting_winnr)
                        end
                    ),
                }
            )
            break
        else
            vim.api.nvim_set_current_win(starting_winnr)
            vim.api.nvim_win_set_cursor(starting_winnr, {i, 0})
            vim.api.nvim_command(line)
        end
    end
end

function M.run_file() run_script(vim.api.nvim_buf_get_lines(0, 0, -1, false)) end

function M.float_shell(cmd) open_floating_terminal(cmd) end
return M
