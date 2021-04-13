# Copyright: (c) 2021, Nick Murphy <comfortablynick@gmail.com>
# Copyright: (c) 2017, Allyson Bowles <@akatch>
# Copyright: (c) 2012-2014, Michael DeHaan <michael.dehaan@gmail.com>
# GNU General Public License v3.0+
# type: ignore

import json
import yaml
import string
import re
import textwrap

from os.path import basename
from ansible import constants as C
from ansible import context
from ansible.module_utils._text import to_text
from ansible.utils.color import colorize, hostcolor
from ansible.parsing.yaml.dumper import AnsibleDumper

from ansible.plugins.callback.default import CallbackModule as CallbackBase
from ansible.plugins.callback import (
    # CallbackBase,
    strip_internal_keys,
    module_response_deepcopy,
)


__metaclass__ = type

DOCUMENTATION = """
    name: unixy_plus
    type: stdout
    author: Nick Murphy <comfortablynick@gmail.com>
    short_description: condensed Ansible output
    description:
      - Consolidated Ansible output in the style of LINUX/UNIX startup logs.
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


class CallbackModule(CallbackBase):

    """
    Design goals:
    - Print consolidated output that looks like a *NIX startup log
    - Defaults should avoid displaying unnecessary information wherever possible

    TODOs:
    - Only display task names if the task runs on at least one host
    - Add option to display all hostnames on a single line in the appropriate result
      color (failures may have a separate line)
    - Consolidate stats display
    - Display whether run is in --check mode
    - Don't show play name if no hosts found
    """

    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = "stdout"
    CALLBACK_NAME = "unixy_plus"

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
            del abridged_result["stdout_lines"]

        # if we already have stderr, we don't need stderr_lines
        if "stderr" in abridged_result and "stderr_lines" in abridged_result:
            del abridged_result["stderr_lines"]

        if abridged_result:
            dumped += "\n"
            dumped += to_text(
                yaml.dump(
                    abridged_result,
                    allow_unicode=True,
                    indent=indent,
                    width=1000,
                    Dumper=AnsibleDumper,
                    default_flow_style=False,
                    sort_keys=sort_keys,
                )
            )

        dumped = textwrap.indent(dumped, "  ")
        return dumped

    def _run_is_verbose(self, result):
        return (
            self._display.verbosity > 0 or "_ansible_verbose_always" in result._result
        ) and "_ansible_verbose_override" not in result._result

    def _get_task_display_name(self, task):
        self.task_display_name = None
        display_name = task.get_name().strip().split(" : ")

        task_display_name = display_name[-1]
        if task_display_name.startswith("include"):
            return
        else:
            self.task_display_name = task_display_name

    def _preprocess_result(self, result):
        self.delegated_vars = result._result.get("_ansible_delegated_vars", None)
        self._handle_exception(result._result, use_stderr=self.display_failed_stderr)
        self._handle_warnings(result._result)

    def _process_result_output(self, result, msg):
        task_host = result._host.get_name()
        task_result = "%s %s" % (task_host, msg)

        if self._run_is_verbose(result):
            task_result = "%s %s: %s" % (
                task_host,
                msg,
                self._dump_results(result._result, indent=4),
            )
            return task_result

        if self.delegated_vars:
            task_delegate_host = self.delegated_vars["ansible_host"]
            task_result = "%s -> %s %s" % (task_host, task_delegate_host, msg)

        if (
            result._result.get("msg")
            and result._result.get("msg") != "All items completed"
        ):
            task_result += " | msg: " + to_text(result._result.get("msg"))

        if result._result.get("stdout"):
            task_result += " | stdout: " + result._result.get("stdout")

        if result._result.get("stderr"):
            task_result += " | stderr: " + result._result.get("stderr")

        return task_result

    def v2_playbook_on_task_start(self, task, is_conditional):
        self._get_task_display_name(task)
        if self.task_display_name is not None:
            # TODO: make this a function
            self._display.display(
                "{}{}".format(
                    self.task_display_name,
                    "." * (self._display.columns - len(self.task_display_name)),
                )
            )

    def v2_playbook_on_handler_task_start(self, task):
        self._get_task_display_name(task)
        if self.task_display_name is not None:
            self._display.display("%s (via handler)... " % self.task_display_name)

    def v2_playbook_on_play_start(self, play):
        name = play.get_name().strip()
        if name and play.hosts:
            msg = "\n- %s on hosts: %s -" % (name, ",".join(play.hosts))
        else:
            msg = "---"

        self._display.display(msg)

    def v2_runner_on_skipped(self, result, ignore_errors=False):
        if self.display_skipped_hosts:
            self._preprocess_result(result)
            display_color = C.COLOR_SKIP
            msg = "skipped"

            task_result = self._process_result_output(result, msg)
            self._display.display("  " + task_result, display_color)
        return

    def v2_playbook_on_include(self, included_file):
        msg = "  %s included: %s" % (
            ", ".join([h.name for h in included_file._hosts]),
            included_file._filename,
        )
        label = self._get_item_label(included_file._vars)
        if label:
            # msg += " => (item=%s)" % label
            msg += "\n" + yaml.dump(label)
        self._display.display(msg, color=C.COLOR_SKIP)

    def v2_runner_on_failed(self, result, ignore_errors=False):
        self._preprocess_result(result)
        display_color = C.COLOR_ERROR
        msg = "failed"
        item_value = self._get_item_label(result._result)
        if item_value:
            msg += " | item: %s" % (item_value,)

        task_result = self._process_result_output(result, msg)
        self._display.display(
            "  " + task_result, display_color, stderr=self.display_failed_stderr
        )

    def v2_runner_on_ok(self, result, msg="ok", display_color=C.COLOR_OK):
        self._preprocess_result(result)
        if "changed" in result._result and result._result["changed"]:
            msg = "done"
            if item_value := self._get_item_label(result._result):
                msg += " | item: {}".format(item_value)
            display_color = C.COLOR_CHANGED
            task_result = self._process_result_output(result, msg)
            self._display.display("  " + task_result, display_color)
        elif self.display_ok_hosts:
            task_result = self._process_result_output(result, msg)
            self._display.display("  " + task_result, display_color)

    def v2_runner_item_on_skipped(self, result):
        self.v2_runner_on_skipped(result)

    def v2_runner_item_on_failed(self, result):
        self.v2_runner_on_failed(result)

    def v2_runner_item_on_ok(self, result):
        self.v2_runner_on_ok(result)

    def v2_runner_on_unreachable(self, result):
        self._preprocess_result(result)

        msg = "unreachable"
        display_color = C.COLOR_UNREACHABLE
        task_result = self._process_result_output(result, msg)

        self._display.display(
            "  " + task_result, display_color, stderr=self.display_failed_stderr
        )

    def v2_on_file_diff(self, result):
        if result._task.loop and "results" in result._result:
            for res in result._result["results"]:
                if "diff" in res and res["diff"] and res.get("changed", False):
                    diff = self._get_diff(res["diff"])
                    if diff:
                        self._display.display(diff)
        elif (
            "diff" in result._result
            and result._result["diff"]
            and result._result.get("changed", False)
        ):
            diff = self._get_diff(result._result["diff"])
            if diff:
                self._display.display(diff)

    def v2_playbook_on_stats(self, stats):
        header = "PLAY RECAP "
        self._display.display(
            "\n{}{}".format(
                header,
                "*" * (self._display.columns - len(header))
            ),
            screen_only=True,
        )

        hosts = sorted(stats.processed.keys())
        for h in hosts:
            # TODO how else can we display these?
            t = stats.summarize(h)
            self._display.display(
                "{:<25} {} {} {} {}".format(
                    hostcolor(h, t).strip(),
                    colorize("ok", t["ok"], C.COLOR_OK),
                    colorize("changed", t["changed"], C.COLOR_CHANGED),
                    colorize("unreachable", t["unreachable"], C.COLOR_UNREACHABLE),
                    colorize("failed", t["failures"], C.COLOR_ERROR),
                ),
                screen_only=True,
            )
            self._display.display(
                "  %s : %s %s %s %s %s %s"
                % (
                    hostcolor(h, t, False),
                    colorize("ok", t["ok"], None),
                    colorize("changed", t["changed"], None),
                    colorize("unreachable", t["unreachable"], None),
                    colorize("failed", t["failures"], None),
                    colorize("rescued", t["rescued"], None),
                    colorize("ignored", t["ignored"], None),
                ),
                log_only=True,
            )
        if stats.custom and self.show_custom_stats:
            self._display.banner("CUSTOM STATS: ")
            # per host
            # TODO: come up with 'pretty format'
            for k in sorted(stats.custom.keys()):
                if k == "_run":
                    continue
                self._display.display(
                    "\t%s: %s"
                    % (
                        k,
                        self._dump_results(stats.custom[k], indent=1).replace("\n", ""),
                    )
                )

            # print per run custom stats
            if "_run" in stats.custom:
                self._display.display("", screen_only=True)
                self._display.display(
                    "\tRUN: %s"
                    % self._dump_results(stats.custom["_run"], indent=1).replace(
                        "\n", ""
                    )
                )
            self._display.display("", screen_only=True)

    def v2_playbook_on_no_hosts_matched(self):
        self._display.display("  No hosts found!", color=C.COLOR_DEBUG)

    def v2_playbook_on_no_hosts_remaining(self):
        self._display.display("  Ran out of hosts!", color=C.COLOR_ERROR)

    def v2_playbook_on_start(self, playbook):
        # TODO display whether this run is happening in check mode
        self._display.display("Executing playbook %s" % basename(playbook._file_name))

        # show CLI arguments
        if self._display.verbosity > 3:
            if context.CLIARGS.get("args"):
                self._display.display(
                    "Positional arguments: %s" % " ".join(context.CLIARGS["args"]),
                    color=C.COLOR_VERBOSE,
                    screen_only=True,
                )

            for argument in (a for a in context.CLIARGS if a != "args"):
                val = context.CLIARGS[argument]
                if val:
                    self._display.vvvv("%s: %s" % (argument, val))

    def v2_runner_retry(self, result):
        msg = "  Retrying... (%d of %d)" % (
            result._result["attempts"],
            result._result["retries"],
        )
        if self._run_is_verbose(result):
            msg += "Result was: %s" % self._dump_results(result._result)
        self._display.display(msg, color=C.COLOR_DEBUG)
