require("nvim_utils")

function text_object_comment(is_visual_mode)
    local visual_mode = VISUAL_MODE.line
    local commentstring = nvim.bo.commentstring
    local function comment_lines(lines)
        local commented = {}
        for _, line in ipairs(lines) do
            table.insert(commented, commentstring:format(line))
        end
        return commented
    end
    if is_visual_mode then
        nvim_buf_transform_region_lines(nil, "<", ">", visual_mode,
                                        comment_lines)
    else
        nvim_text_operator_transform_selection(comment_lines, visual_mode)
    end
end

local function text_object_define(mapping, function_name)
    local options = {silent = true, noremap = true}
    nvim.set_keymap("n", mapping,
                    ("<Cmd>lua %s(%s)<CR>"):format(function_name, "false"),
                    options)
    nvim.set_keymap("x", mapping,
                    (":lua %s(%s)<CR>"):format(function_name, "true"), options)
end

function TestComment()
    text_object_define(",e", "text_object_comment")
end
