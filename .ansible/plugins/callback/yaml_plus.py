# (c) 2021 Nick Murphy <comfortablynick@gmail.com>
# (c) 2017 Ansible Project
# GNU General Public License v3.0+
# type: ignore

__metaclass__ = type

import yaml
import json
import re
import string

from ansible.module_utils._text import to_text

# from ansible.module_utils.six import string_types
from ansible.parsing.yaml.dumper import AnsibleDumper
from ansible.plugins.callback import (
    strip_internal_keys,
    module_response_deepcopy,
)
from ansible.plugins.callback.default import CallbackModule as Default

DOCUMENTATION = """
    author: Nick Murphy <comfortablynick@gmail.com>
    name: yaml_plus
    type: stdout
    short_description: yaml-ized Ansible screen output
    description:
        - Ansible output that can be quite a bit easier to read than the
          default JSON formatting.
    extends_documentation_fragment:
      - default_callback
    requirements:
      - set as stdout in configuration
"""


# from http://stackoverflow.com/a/15423007/115478
def should_use_block(value):
    """Returns true if string should be in block format"""
    for c in "\n\r\x1c\x1d\x1e\x85\u2028\u2029":
        if c in value:
            return True
    return False


def my_represent_scalar(self, tag, value, style=None):
    """Uses block style for multi-line strings"""
    if style is None:
        if should_use_block(value):
            style = "|"
            # we care more about readable than accuracy, so...
            # ...no trailing space
            value = value.rstrip()
            # ...and non-printable characters
            value = "".join(x for x in value if x in string.printable or ord(x) >= 0xA0)
            # ...tabs prevent blocks from expanding
            value = value.expandtabs()
            # ...and odd bits of whitespace
            value = re.sub(r"[\x0b\x0c\r]", "", value)
            # ...as does trailing space
            value = re.sub(r" +\n", "\n", value)
        else:
            style = self.default_style
    node = yaml.representer.ScalarNode(tag, value, style=style)
    if self.alias_key is not None:
        self.represented_objects[self.alias_key] = node
    return node


class CallbackModule(Default):

    """Variation of the Default output which uses nicely readable YAML instead
    of JSON for printing results.
    """

    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = "stdout"
    CALLBACK_NAME = "yaml_plus"

    def __init__(self):
        super(CallbackModule, self).__init__()
        yaml.representer.BaseRepresenter.represent_scalar = my_represent_scalar

    def _dump_results(self, result, indent=None, sort_keys=True, keep_invocation=False):
        if result.get("_ansible_no_log", False):
            return json.dumps(
                dict(
                    censored=(
                        "The output has been hidden due to the fact that"
                        "'no_log: true' was specified for this result"
                        )
                ),
                sort_keys=sort_keys,
                indent=indent,
            )

        # All result keys stating with _ansible_ are internal,
        # so remove them from the result before we output anything.
        abridged_result = strip_internal_keys(module_response_deepcopy(result))

        # remove invocation unless specifically wanting it
        if (
            not keep_invocation
            and self._display.verbosity < 3
            and "invocation" in result
        ):
            del abridged_result["invocation"]

        # remove diff information from screen output
        if self._display.verbosity < 3 and "diff" in result:
            del abridged_result["diff"]

        # remove exception from screen output
        if "exception" in abridged_result:
            del abridged_result["exception"]

        dumped = ""

        # put changed and skipped into a header line
        if "changed" in abridged_result:
            dumped += "changed=" + str(abridged_result["changed"]).lower() + " "
            del abridged_result["changed"]

        if "skipped" in abridged_result:
            dumped += "skipped=" + str(abridged_result["skipped"]).lower() + " "
            del abridged_result["skipped"]

        # if we already have stdout, we don't need stdout_lines
        if "stdout" in abridged_result and "stdout_lines" in abridged_result:
            # abridged_result["stdout_lines"] = "<omitted>"
            del abridged_result["stdout_lines"]

        # if we already have stderr, we don't need stderr_lines
        if "stderr" in abridged_result and "stderr_lines" in abridged_result:
            # abridged_result["stderr_lines"] = "<omitted>"
            del abridged_result["stderr_lines"]

        if abridged_result:
            dumped += "\n"
            dumped += to_text(
                yaml.dump(
                    abridged_result,
                    allow_unicode=True,
                    width=1000,
                    Dumper=AnsibleDumper,
                    default_flow_style=False,
                )
            )

        # indent by a couple of spaces
        dumped = "\n  ".join(dumped.split("\n")).rstrip()
        return dumped

    def _serialize_diff(self, diff):
        return to_text(
            yaml.dump(
                diff,
                allow_unicode=True,
                width=1000,
                Dumper=AnsibleDumper,
                default_flow_style=False,
            )
        )
