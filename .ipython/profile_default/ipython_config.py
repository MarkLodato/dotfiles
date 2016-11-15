
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
c.TerminalInteractiveShell.readline_parse_and_bind = [
    'tab: complete',
]

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
c.AliasManager.user_aliases = [
    ('git', 'git'),
]
