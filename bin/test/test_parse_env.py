#!/usr/bin/env python3

import types
import unittest
from importlib.machinery import SourceFileLoader
from importlib.util import module_from_spec, spec_from_loader
from subprocess import run


def import_from_source(name: str, file_path: str) -> types.ModuleType:
    loader = SourceFileLoader(name, file_path)
    spec = spec_from_loader(loader.name, loader)
    module = module_from_spec(spec)
    loader.exec_module(module)
    return module


parse_env = import_from_source("parse_env", "../parse_env")


class Test(unittest.TestCase):
    # def test_shell(self):
    #     self.assertTrue(parse_env.is_shell_match(["fish"], ["common"]))

    def test_path_var(self):
        before = """
        [[path]]
        val = '$HOME/.local/bin'
        """
        after = "fish_add_path $HOME/.local/bin"
        result = run(
            "parse_env -s fish".split(), input=before, text=True, capture_output=True
        )
        out = "\n".join(result.stdout.splitlines()[1:])
        self.assertEqual(out, after)


if __name__ == "__main__":
    unittest.main()
    print(parse_env.__doc__)
