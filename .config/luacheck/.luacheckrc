-- vim:ft=lua:
-- luacheck: ignore 131
stds.nvim = {
    globals = {
        "vim",
        "unpack",
        "nvim",
        "p",
        string = {fields = {basename = {}}},
        table = {fields = {print = {}}},
    },
    read_globals = {string = {fields = {basename = {}}}},
}
std = "min+nvim"
codes = true
allow_defined = true
-- ignore = {"131"}
