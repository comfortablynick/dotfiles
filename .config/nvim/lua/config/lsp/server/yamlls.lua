-- luacheck: no max line length
local util = require "lspconfig/util"

return function(on_attach)
  return {
    cmd = { "yaml-language-server", "--stdio" },
    on_attach = on_attach,
    root_dir = function(fname)
      return util.root_pattern(".git", ".yamllint", ".projections.json")(fname)
        or util.find_git_ancestor(fname)
        or util.path.dirname(fname)
    end,
    settings = {
      yaml = {
        format = { enable = true, printWidth = 100 },
        schemas = {
          ["https://raw.githubusercontent.com/ansible-community/schemas/main/f/ansible-tasks.json"] = "tasks/**/*.yml",
          ["https://raw.githubusercontent.com/ansible-community/schemas/main/f/ansible-playbook.json"] = ".ansible/playbooks/*.yml",
          ["https://gist.githubusercontent.com/KROSF/c5435acf590acd632f71bb720f685895/raw/6f11aa982ad09a341e20fa7f4beed1a1b2a8f40e/taskfile.schema.json"] = "Taskfile.yml",
        },
      },
    },
  }
end
