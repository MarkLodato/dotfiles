c = get_config()

c.TerminalIPythonApp.display_banner = False
c.TerminalInteractiveShell.confirm_exit = False
c.TerminalInteractiveShell.term_title = True

# Enable 'aimport foo' to turn on autoreloading of module 'foo'.
c.TerminalIPythonApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = ['autoreload 1']

# Undo IPython's annoying remapping of the cursor keys.
c.TerminalInteractiveShell.readline_parse_and_bind = [
    '"\Cp": previous-history',
    '"\Cn": next-history',
    '"\e[A": previous-history',
    '"\e[B": next-history',
]

# Make the IPython prompt look like the regular Python one.
c.PromptManager.in_template = '>>> '
c.PromptManager.in2_template = '... '
c.PromptManager.out_template = ''
c.PromptManager.justify = False

# Set up aliases for shell commands.
c.AliasManager.user_aliases = [
    ('git', 'git'),
]
