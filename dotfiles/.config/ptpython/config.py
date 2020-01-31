"""Configuration for `ptpython` REPL."""
from __future__ import unicode_literals

from prompt_toolkit.filters import ViInsertMode
from prompt_toolkit.key_binding.key_processor import KeyPress
from prompt_toolkit.keys import Keys
from ptpython.layout import CompletionVisualisation
from pygments.token import Token

__all__ = ("configure",)


def configure(repl):
    """
    Configuration method. This is called during the start-up of ptpython.

    :param repl: `PythonRepl` instance.
    """
    repl.show_signature = False  # not needed if docstring shown
    repl.show_docstring = True
    repl.show_meta_enter_message = True
    repl.completion_visualisation = (
        CompletionVisualisation.MULTI_COLUMN
    )  # (NONE, POP_UP, MULTI_COLUMN or TOOLBAR)
    repl.completion_menu_scroll_offset = 0
    repl.show_line_numbers = False
    repl.show_status_bar = True
    repl.show_sidebar_help = True
    repl.highlight_matching_parenthesis = True
    repl.wrap_lines = True
    repl.enable_mouse_support = False
    repl.complete_while_typing = True
    repl.vi_mode = True
    repl.paste_mode = False
    repl.prompt_style = "classic"  # 'classic'(>>>) or 'ipython' (In [1])
    repl.insert_blank_line_after_output = False

    # Paste mode. (When True, don't insert whitespace after new line.)
    # History Search.
    # When True, going back in history will filter the history on the records
    # starting with the current input. (Like readline.)
    # Note: When enable, please disable the `complete_while_typing` option.
    #       otherwise, when there is a completion available, the arrows will
    #       browse through the available completions instead of the history.
    repl.enable_history_search = False
    repl.enable_auto_suggest = True
    repl.enable_open_in_editor = True  # C-X C-E emacs mode/'v' for VI
    repl.enable_system_bindings = True  # meta-! will display the system prompt.
    repl.confirm_exit = True
    repl.enable_input_validation = True  # Don't execute when syntax errors
    repl.use_code_colorscheme("paraiso-dark")
    repl.color_depth = "DEPTH_8_BIT"  # The default, 256 colors Also: 1, 4, 24.
    repl.enable_syntax_highlighting = True

    @repl.add_key_binding("k", "j", filter=ViInsertMode())
    def _(event):
        " Map 'kj' to Escape. "
        event.cli.key_processor.feed(KeyPress(Keys.Escape))

    # Sample configurations {{{1
    # Install custom colorscheme named 'my-colorscheme' and use it.
    """
    repl.install_ui_colorscheme('my-colorscheme', _custom_ui_colorscheme)
    repl.use_ui_colorscheme('my-colorscheme')
    """

    # Add custom key binding for PDB.
    """
    @repl.add_key_binding(Keys.ControlB)
    def _(event):
        ' Pressing Control-B will insert "pdb.set_trace()" '
        event.cli.current_buffer.insert_text('\nimport pdb; pdb.set_trace()\n')
    """

    # Typing ControlE twice should also execute the current command.
    # (Alternative for Meta-Enter.)
    """
    @repl.add_key_binding(Keys.ControlE, Keys.ControlE)
    def _(event):
        b = event.current_buffer
        if b.accept_action.is_returnable:
            b.accept_action.validate_and_handle(event.cli, b)
    """

    # Typing 'jj' in Vi Insert mode, should send escape. (Go back to navigation
    # mode.)
    """
    @repl.add_key_binding('j', 'j', filter=ViInsertMode())
    def _(event):
        " Map 'jj' to Escape. "
        event.cli.key_processor.feed(KeyPress(Keys.Escape))
    """

    # Custom key binding for some simple autocorrection while typing.
    """
    corrections = {
        'impotr': 'import',
        'pritn': 'print',
    }

    @repl.add_key_binding(' ')
    def _(event):
        ' When a space is pressed. Check & correct word before cursor. '
        b = event.cli.current_buffer
        w = b.document.get_word_before_cursor()

        if w is not None:
            if w in corrections:
                b.delete_before_cursor(count=len(w))
                b.insert_text(corrections[w])

        b.insert_text(' ')
    """


# Custom colorscheme for the UI. See `ptpython/layout.py` and
# `ptpython/style.py` for all possible tokens.
_custom_ui_colorscheme = {
    # Blue prompt.
    Token.Layout.Prompt: "bg:#eeeeff #000000 bold",
    # Make the status toolbar red.
    Token.Toolbar.Status: "bg:#ff0000 #000000",
}
