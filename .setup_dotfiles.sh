#!/bin/bash

set -o nounset
set -o errexit

PROG=$(basename "$0")

# cd to the directory containing this script.
cd "$( dirname "${BASH_SOURCE[0]}" )"
THIS_DIR=$(pwd)

usage() {
    cat <<EOF
USAGE: $PROG [-f|--force] [-b <branch>|-B <branch>]

Checks out the dotfiles from $THIS_DIR into \$HOME.

Options:
    -b <branch>     Use <branch> for \$HOME (default "home")
    -B <branch>     Same as -b but allow existing branch names; use with care.
    -f, --force     Overwrite locally modified versions of dotfiles in \$HOME.
EOF
}

OPTS=$(getopt -o 'hfb:B:' -l 'help,force' -n "$PROG" -- "$@")
set -- $OPTS

FORCE=
BRANCH=home
BRANCH_FLAG=-b
while (( $# > 0 )); do
    case "$1" in
        -f|--force)
            FORCE=-f
            shift
            ;;
        -b|-B)
            BRANCH_FLAG="$1"
            BRANCH="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            ;;
        -*)
            echo "$PROG: programming error - unrecognized option '$1'" >&2
            exit 2
            ;;
        *)
            # No positional arguments expected
            usage >&2
            exit 2
            ;;
    esac
done

echo "Creating fake worktree ~/.dotfiles"
git worktree add $BRANCH_FLAG "$BRANCH" --track --no-checkout ~/.dotfiles master

cat >~/.dotfiles/README <<EOF
This is a fake git worktree. The actual worktree is $HOME.
See $THIS_DIR/README.md for more info.
EOF

GD_ALIAS='git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME"'
gd() { git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME" "$@"; }

# Go to the home directory so all paths are printed nicely, not "../../<file>".
cd

# `git worktree add --no-checkout` leaves the index in a funky state; reset it
# so that we see what files are missing.
gd reset --quiet

echo "Checking out files to $HOME"
RC=0
gd checkout-index -a $FORCE || RC=$?

cat <<EOF

Done! Use the following alias to manage the dotfiles:
        alias gd='$GD_ALIAS'
EOF

if (( RC != 0 )); then
    cat <<EOF

WARNING: Some files were left unmodified. Use the following to check them out:
        gd checkout -p ~
Remove the -p to simply blow away the existing versions.
EOF
fi
