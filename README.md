## My Dotfiles

This repository contains my Linux dotfiles.

### Installation

It is not possible to check out the repo directly to $HOME, or else git would
think *everything* in the home directory is part of this repo.  Instead, we
need to jump through the following hoops:

    $ cd
    $ git clone -n https://github.com/MarkLodato/dotfiles.git dotfiles.tmp
    $ mv dotfiles.tmp/.git .dotfiles.git
    $ rmdir dotfiles.tmp
    $ alias gd='git --git-dir="$HOME/.dotfiles.git" --work-tree="$HOME"'
    $ gd checkout ~
    $ vim +PlugInstall +qall
    $ mkdir p
    $ cd p
    $ git clone https://github.com/MarkLodato/git-reparent
    $ git clone https://github.com/MarkLodato/scripts
    $ git clone https://github.com/so-fancy/diff-so-fancy

Explanation: First, we check out the repository and move the .git directory to
~/.dotfiles.git.  (We do not use `git clone --bare` because that would tell git
that it is a "bare" repository without a working directory, which is not true.)
Then, we set up an alias, `gd`, to tell git where our git directory is.  This is
exactly what .zshrc does.  The final step is to update $HOME with the files from
the repository.

From now on, use `gd` instead of `git`.  Examples:

    $ gd add -p
    $ gd commit

The .gitignore is set up to monitor any new dotfiles but to ignore files not
starting with a dot at the top level.  That way, `git status` will indicate any
new files that should be added to (or ignored by) the repository.

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

## XCompose

I am using [pointless-xcompose][] for the compose key.  It is included in the
.pointless-xcompose/ directory using `git subtree`.  To update it, first add
it as a remote:

    $ git remote add pointless-xcompose https://github.com/rrthomas/pointless-xcompose.git

From then on, update it using:

    $ git fetch pointless-xcompose
    $ git subtree pull --squash --prefix=.pointless-xcompose pointless-xcompose master

[pointless-xcompose]: https://github.com/rrthomas/pointless-xcompose
