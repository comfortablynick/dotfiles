-- Test vim package manager
--
-- local vim = vim
-- local a = vim.api
local pkg = {}

-- TODO: walk dir structure, fetch repos, and report which ones have updates
function pkg.git_status()
    local gs = io.popen("git status --porcelain=2 --branch", "r")
    local out = gs:read("*all")
    gs:close()
    return out
end

function pkg.scandir(directory)
    local pfile = assert(
                      io.popen(

                              ("find %s -type d -exec test -e '{}/.git' ';' -print0 -prune"):format(
                                  directory
                              ), "r"
                      )
                  )
    local list = pfile:read("*a")
    pfile:close()

    local folders = {}

    for filename in string.gmatch(list, "[^%z]+") do
        table.insert(folders, filename)
    end

    return folders
end

function pkg.git_dirs()
    local packdir = vim.g.package_path .. "/packager"
    local subdirs = pkg.scandir(packdir)
    return print(vim.inspect(subdirs))
end

-- all funcs before this line
return pkg
