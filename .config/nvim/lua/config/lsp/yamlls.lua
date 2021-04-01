local util = require"lspconfig/util"

return function(on_attach)
  return {
    cmd = {"yaml-language-server", "--stdio"},
    on_attach = on_attach,
    filetypes = {"yaml", "yaml.ansible"},
    root_dir = function(fname)
      return util.root_pattern(".git", ".yamllint", ".projections.json")(fname) or
               util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    settings = {
      yaml = {
        format = {enable = true, printWidth = 100},
        schemas = {
          ["https://json.schemastore.org/ansible-playbook"] = ".ansible/playbooks/*.yml",
          ["https://json.schemastore.org/ansible-role-2.9"] = ".ansible/roles/*/tasks/*.yml",
          ["https://gist.githubusercontent.com/KROSF/c5435acf590acd632f71bb720f685895/raw/6f11aa982ad09a341e20fa7f4beed1a1b2a8f40e/taskfile.schema.json"] = "Taskfile.yml", -- luacheck: no max line length
        },
      },
    },
  }
end
