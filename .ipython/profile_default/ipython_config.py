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

# The following disables up/down arrow history search, but also stupidly turns
# on extremely slow completion for which there is no way to disable.
#c.TerminalInteractiveShell.enable_history_search = False

# Enable 'aimport foo' to turn on autoreloading of module 'foo'.
c.TerminalIPythonApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = ['autoreload 1']

# Revert to old readline library so I get all my bindings.
# Requires `pip install rlipython`.
# TODO: Configure the prompt to look like regular python (>>>). Look in the git
# history to see how this used to be done before rlipython.
#c.TerminalIPythonApp.interactive_shell_class = 'rlipython.TerminalInteractiveShell'

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
