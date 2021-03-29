from distutils.version import LooseVersion
import subprocess
from os.path import expanduser, expandvars, isdir
import re


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


def is_dir(value):
    """Test if value is dir."""
    val = expandvars(expanduser(value))
    return isdir(val)


def quote(value):
    """Quote value if there is whitespace."""
    if re.compile(r"\s").search(value) is not None:
        return repr(value)
    return value


def if_is_dir(value, default=None):
    """Return default if value is not dir."""
    return value if is_dir(value) else default


class FilterModule:
    _filters = {
        "sort_versions": sort_versions,
        "shell_eval": do_shell_eval,
        "shell_if": do_shell_test,
        "is_dir": is_dir,
        "if_is_dir": if_is_dir,
        "q": quote,
    }

    def filters(self):
        return self._filters
