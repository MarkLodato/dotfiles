## My Dotfiles

This repository contains my Linux dotfiles.

### Installation and usage

Quickstart:

    mkdir -p ~/p
    cd ~/p
    git clone https://github.com/MarkLodato/dotfiles
    git clone https://github.com/MarkLodato/git-reparent
    git clone https://github.com/MarkLodato/scripts
    git clone https://github.com/so-fancy/diff-so-fancy
    dotfiles/.setup_dotfiles.sh
    vim +PlugInstall +qall
    vim '+UnicodeDownload!' +qall
    sudo apt install libterm-readkey-perl zsh hub tmux
    sudo usermod -s "$(command -v zsh)" "$USER"

From now on, use `gd` instead of `git` to manage dotfiles.  Examples:

    $ gd add -p
    $ gd commit

The .gitignore is set up to monitor any new dotfiles but to ignore files not
starting with a dot at the top level.  That way, `git status` will indicate any
new files that should be added to (or ignored by) the repository.

There are two branches:

*   `master`, which is checked out at `~/p/dotfiles` and is pushed to GitHub
*   `home`, which is checked out at `~` and is local to the machine

To pull changes from GitHub:

    $ cd ~/p/dotfiles
    $ git pull --ff-only
    $ gd merge --ff-only

To push changes to GitHub:

    $ cd ~/p/dotfiles
    $ git merge --ff-only home
    $ git push

#### Explanation

It is undesirable to check out the repo directly to `~` because then git would
think *everything* in the home directory is part of this repo. Instead we move
the .git directory elsewhere and specify `--git-dir=... --work-tree=$HOME` via
an alias, `gd`. This way we only manage dotfiles intentionally.

We also maintain two separate
[worktrees](https://git-scm.com/docs/git-worktree), `~` and `~/p/dotfiles`, on
branches `home` and `master`, respectively. This dual-worktree setup allows us
to carefully control what gets pushed to GitHub. It also allows us to avoid
messing up our live dotfiles with merge conflicts.

The `.setup_dotfiles.sh` script creates a dummy alternate worktree at
`~/.dotfiles` and then checks out the files to `$HOME`.

#### Alternate Installation

An alternate, much more widely suggested strategy is to check out the files to
a subdirectory and then set up symlinks for each file.  While this is easier to
understand, it requires much more maintenance and does not automatically detect
new files.

### Highlights

#### zsh: calc and pycalc

Use `calc` to do simple math, which is a convenient wrapper around `$(( ))`.

    $ calc 1 + 2
    3
    $ calc log2(3**5)
    7.9248125036057813
    $ calc -b 16 0x1000 + 12
    0x100C

When that won't do, use `pycalc` to run the given expression through `python`.
This is significantly slower than `calc`.

#### zsh: cycle-quotes

Press <kbd>ALT-'</kbd> to cycle the quoting of the current argument between
single quoting, double quoting, backslash escaping, and back to the original
(if different from one of the others.)  For example, by repeatedly pressing
<kbd>ALT-'</kbd> when the cursor is on the last argument, one cycles through
the following:

    $ foo bar --flag=one\ 'two $three'
    $ foo bar '--flag=one two $three'
    $ foo bar "--flag=one two \$three"
    $ foo bar --flag=one\ two\ \$three

#### zsh: increment-number

Press <kbd>^X ^A</kbd> or <kbd>^X ^X</kbd> to increment or
decrement the decimal number on, to the right of, or to the left of the
cursor, just like in Vim.  (Unlike Vim, we increment the number to the left of
the cursor if none exist on or to the right.)  For example, the following
works anywhere on the line because there is only one number (note how leading
zeros are preserved):

    $ mplayer track01.wav           ->      $ mplayer track02.wav

However, if there were two numbers, position your cursor on or to the left of
the number to increment it.  In the following examples, `^` indicates cursor
position when <kbd>^X ^A</kbd> is pressed.

    $ cp foo.001 foo.001 dir        ->      $ cp foo.001 foo.002 dir
                            ^
    $ cp foo.001 foo.001 dir        ->      $ cp foo.001 foo.002 dir
                  ^
    $ cp foo.001 foo.001 dir        ->      $ cp foo.002 foo.001 dir
          ^
