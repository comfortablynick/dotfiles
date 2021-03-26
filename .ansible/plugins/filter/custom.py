from distutils.version import LooseVersion
import subprocess


def sort_versions(value):
    """Sort semantic version numbers (strings)."""
    return sorted(value, key=LooseVersion)


def do_shell_eval(value):
    """Use shell to evaluate value and return result."""
    res = subprocess.run(value, shell=True, text=True, capture_output=True)
    return res.stdout


def do_shell_test(value):
    """Use shell to evaluate value and return status code."""
    res = subprocess.run(value, shell=True, text=True, capture_output=True)
    return res.returncode == 0


class FilterModule:
    _filters = {
        "sort_versions": sort_versions,
        "shell_eval": do_shell_eval,
        "shell_if": do_shell_test,
    }

    def filters(self):
        return self._filters
