return {
  cmd = {"yaml-language-server", "--stdio"},
  filetypes = {"yaml", "yaml.ansible"},
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/ansible-role-2.9"] = ".ansible/roles/*/*.yml",
        ["https://gist.githubusercontent.com/KROSF/c5435acf590acd632f71bb720f685895/raw/6f11aa982ad09a341e20fa7f4beed1a1b2a8f40e/taskfile.schema.json"] = "Taskfile.yml",
      },
    },
  },
}
