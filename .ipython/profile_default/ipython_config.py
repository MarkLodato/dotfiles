import IPython
import signal
import sys

# shutil.get_terminal_size is only Python 3.
# To make this work in Python 2, do:
#       pip install backports.shutil_get_terminal_size
try:
    from shutil import get_terminal_size
except ImportError:
    try:
        from backports.shutil_get_terminal_size import get_terminal_size
    except ImportError:
        get_terminal_size = None

# Import numpy now to set the terminal width. I could use wrapt to delay the
# terminal width setting until it is actually loaded, but that seems more
# complicated than it is worth.
# http://stackoverflow.com/a/40624185/303425
try:
    import numpy as np
except ImportError:
    pass

c = get_config()

c.InteractiveShell.colors = 'Linux'  # Use dark background color scheme.
c.TerminalIPythonApp.display_banner = False
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.term_title = True

# Enable 'aimport foo' to turn on autoreloading of module 'foo'.
c.TerminalIPythonApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = ['autoreload 1']

# IPython's default readline config remaps the cursor keys to do history
# searches, which is extremely annoying.  By setting this here, we prevent *all*
# of the default mappings, the only of which we care about is tab completion.
c.TerminalInteractiveShell.readline_parse_and_bind = ['tab: complete', ]

# Make the IPython prompt look like the regular Python one.
try:
    from IPython.terminal.prompts import Prompts, Token
except ImportError:
    c.PromptManager.in_template = '>>> '
    c.PromptManager.in2_template = '... '
    c.PromptManager.out_template = ''
    c.PromptManager.justify = False
else:

    class BasicPythonPrompt(Prompts):
        """Emulates the regular python interactive prompt."""

        def in_prompt_tokens(self, cli=None):
            return [(Token.Prompt, '>>> ')]

        def continuation_prompt_tokens(self, cli=None, width=None):
            return [(Token.Prompt, '... ')]

        def out_prompt_tokens(self, cli=None):
            return []

    c.TerminalInteractiveShell.prompts_class = BasicPythonPrompt

# Set up aliases for shell commands.
c.AliasManager.user_aliases = [('git', 'git'), ]


if get_terminal_size is not None:
    def update_terminal_width(*ignored):
        """Resize the IPython and numpy printing width to match the terminal."""
        w, h = get_terminal_size()

        config = IPython.get_ipython().config
        config.PlainTextFormatter.max_width = w - 1
        shell = IPython.core.interactiveshell.InteractiveShell.instance()
        shell.init_display_formatter()

        if 'numpy' in sys.modules:
            import numpy as np
            np.set_printoptions(linewidth=w - 5)

    # We need to configure IPython here differently because get_ipython() does
    # not yet exist.
    w, h = get_terminal_size()
    c.PlainTextFormatter.max_width = w - 1
    if 'numpy' in sys.modules:
        import numpy as np
        np.set_printoptions(linewidth=w - 5)

    signal.signal(signal.SIGWINCH, update_terminal_width)
