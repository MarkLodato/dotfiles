## My Dotfiles

This repository contains my Linux dotfiles.

### Installation

It is not possible to check out the repo directly to $HOME, or else git would
think *everything* in the home directory is part of this repo.  Instead, we
need to jump through the following hoops:

    $ cd
    $ git clone -n https://github.com/MarkLodato/dotfiles.git dotfiles.tmp
    $ mv dotfiles.tmp/.git dotfiles.git
    $ rmdir dotfiles.tmp
    $ alias gd='git --git-dir=$HOME/dotfiles.git --work-tree=$HOME'
    $ gd checkout ~

Explanation: First, we check out the repository and move the .git directory to
~/dotfiles.git.  (We do not use `git clone --bare` because that would tell git
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

### Alternate Installation

An alternate, much more widely suggested strategy is to check out the files to
a subdirectory and then set up symlinks for each file.  While this is easier to
understand, it requires much more maintenance and does not automatically detect
new files.
