# ----------------------------------------------------------------------------
#                        Machine-specific Configuration
# ----------------------------------------------------------------------------

[[ -r ~/.zsh/rc-private-top.zsh ]] && source ~/.zsh/rc-private-top.zsh

[[ -z $MY_MACHINE ]] && MY_MACHINE=
[[ -z $THIS_MACHINE ]] && THIS_MACHINE=$(hostname -s)


# ----------------------------------------------------------------------------
#                                Miscellaneous
# ----------------------------------------------------------------------------

[ -d ~/.zsh/functions ] && fpath=(~/.zsh/functions $fpath)

# Use 256-color extension if available.
if [[ "$TERM" == "xterm" ]] && echo $XTERM_VERSION | grep -q '^XTerm'; then
  export TERM=xterm-256color
fi

# If we are SSHing in, set up D-Bus to use the instance that was started up
# during the graphical login (display :0 which is where the "-0" comes from).
if [[ -z $DBUS_SESSION_BUS_ADDRESS ]]; then
  if [[ -f ~/.dbus/session-bus/$(dbus-uuidgen --get)-0 ]]; then
    source ~/.dbus/session-bus/$(dbus-uuidgen --get)-0
    export DBUS_SESSION_BUS_ADDRESS
  fi
fi

chpwd_functions=()
precmd_functions=()
preexec_functions=()


# ----------------------------------------------------------------------------
#                        Aliases / Commands / Variables
# ----------------------------------------------------------------------------

source ~/.zsh/calc.zsh
alias calchex='noglob calc -b 16'
alias calc='noglob calc'
zmodload zsh/mathfunc
autoload zmathfuncdef

zmathfuncdef log2 'log($1)/log(2)' 2>/dev/null
zmathfuncdef lnPr '(lgamma(($1)+1)-lgamma(($1)-($2)+1))/log(2)' 2>/dev/null
zmathfuncdef lnCr '(lgamma(($1)+1)-lgamma(($1)-($2)+1)-lgamma(($2)+1))/log(2)' 2>/dev/null
zmathfuncdef nPr '2 ** lnPr(($1),($2))' 2>/dev/null
zmathfuncdef nCr '2 ** lnCr(($1),($2))' 2>/dev/null
zmathfuncdef fact 'exp(lgamma(($1)+1))' 2>/dev/null
zmathfuncdef lfact 'lgamma(($1)+1)/log(2)' 2>/dev/null

alias pycalc='pycalc3'
alias pycalc2='noglob python ~/.zsh/pycalc.py'
alias pycalc3='noglob python3 ~/.zsh/pycalc.py'

# SVN stuff
function svndo() {
  to=$_
  action=$1
  shift
  if [[ $# -lt 3 ]]; then
    echo USAGE: $0 ACTION SRC... DEST
  else
    while [[ $# -gt 1 ]]; do
      svn $action $1 $to
      shift
    done
  fi
}
alias svnmove='svndo mv'
alias svncopy='svndo cp'

# zmv is awesome.  You can do "mmv *.cc *.cpp" to rename all .cc files to .cpp.
# Type "zmv" for more info.
autoload -U zmv
alias mmv='noglob zmv -W'
alias mcp='noglob zmv -WC'

# zargs is like xargs, but you can use globbing
autoload zargs

if ls --help | grep -q -e --color; then
  alias ls='ls --color=auto'
fi
alias lsa='ls -A'
alias ll='ls -lh'
alias lla='ls -la'
if grep --help | grep -q -e --color; then
  alias grep='grep --color=auto'
fi
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias diff='diff -u'
alias gdiff='git diff --no-index --no-prefix'
alias gdiffw='git diff --no-index --no-prefix --color-words'
alias ggrep='git grep --no-index'
alias chrome='google-chrome'

# `yesno` is useful for experimentally testing conditionals.
# Example: [[ $x = *foo* ]]; yesno
alias yesno='[[ $? -eq 0 ]] && echo yes || echo no'

# `swhich` chases down and expands all symlinks in the path to its argument
# using type(1) and readlink(1).  Since it substitutes its argument into the
# expanded command ith as to be implemented as a function rather than an alias.
function swhich { whence -pcs $* | sed -e 's/.* -> //' }
alias switch=swhich

# `pager_if_tty` runs `$PAGER` if stdout is a tty, else `cat`.  To be used
# by functions that automatically spawn a pager.  With this, such functions
# can still be piped without problem.
function pager_if_tty {
  if [[ -t 1 ]]; then
    "${PAGER:-less}"
  else
    cat
  fi
}

# `mkcd` does `mkdir` followed by `cd`.
function mkcd { mkdir "$@" && cd "$@" }

# `cda` resolves all symlinks in the current directory.
# `cda <dir>` changes to <dir> and then does `cda`.
function cda {
  if [[ $# -gt 1 ]]; then
    echo "USAGE: $0 [directory]" >&2
    return
  fi
  local orig="$1"
  [[ -z $orig ]] && orig="$PWD"
  local final="$(readlink -f "$orig")"
  local rc=$?
  [[ $rc -ne 0 ]] && return $rc
  cd $final || return $rc
}

# Keep the dotfiles in a git repository.  We can't keep the git repo at ~/.git,
# because then git will think we're *always* in a git repository.  So, we
# instead put the repository on NFS and use this "gd" alias to manage dotfiles.
# We could use symlinks intead, but this seems easier.
if [[ -z $HOME_GITDIR ]]; then
  for HOME_GITDIR in ~/p/dotfiles.git ~/personal/dotfiles.git \
                     ~/dotfiles.git; do
    if [[ -d $HOME_GITDIR ]]; then
      break
    fi
  done
fi
alias gd='git --git-dir=$HOME_GITDIR --work-tree=$HOME'


# ----------------------------------------------------------------------------
#                                 Key Bindings
# ----------------------------------------------------------------------------

# Use emacs key bindings, and allow META- to be the same as ESC.
bindkey -e -m 2>/dev/null

# Make ALT-> (or ESC >) cycle through the previous words on the line.  If you
# use ALT-. to go to a previous line, ALT-> will go through the words on that
# line.  You can also use a numeric argument to specify which word to get
# (neg = from end of line, pos = from beginning).
autoload copy-earlier-word
zle -N copy-earlier-word
bindkey '\e>' copy-earlier-word
bindkey '\M->' copy-earlier-word

# Find home, insert, delete, and end.
bindkey '\e[1~' beginning-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\e[H~' beginning-of-line
bindkey '\e[2~' overwrite-mode
bindkey '\e[3~' delete-char
bindkey '\e[4~' end-of-line
bindkey '\e[8~' end-of-line
bindkey '\e[F~' end-of-line

# Mac command-arrow keys (in Secure Shell plugin, at least.)
# Cmd-Up (\e\e[A) and Cmd-Down (\e\e[B) are unbound.
bindkey '\e\e[C' end-of-line        # Cmd-Right
bindkey '\e\e[D' beginning-of-line  # Cmd-Left

# Add some vi commands to emacs mode
#bindkey '^xf' vi-find-next-char
#bindkey '^xF' vi-find-prev-char
#bindkey '^xt' vi-find-next-char-skip
#bindkey '^xT' vi-find-prev-char-skip
#bindkey '^x;' vi-repeat-find
#bindkey '^x,' vi-rev-repeat-find
#bindkey '\ee' vi-forward-blank-word-end
#bindkey '\eE' vi-forward-blank-word-end
#bindkey '\M-e' vi-forward-blank-word-end
#bindkey '\M-E' vi-forward-blank-word-end

# Make word skipping in emacs work like vi
#bindkey '\ee' vi-forward-word-end
#bindkey '\eE' vi-forward-blank-word-end
#bindkey '\eb' vi-backward-word
#bindkey '\eB' vi-backward-blank-word
#bindkey '\ef' vi-forward-word
#bindkey '\eF' vi-forward-blank-word

# Modify the vi commands to make them like Vim.
bindkey -M vicmd 'u' undo
bindkey -M vicmd '^r' redo
bindkey -M vicmd 'Y' vi-yank-eol

# Useful bindings.  META-p (META-n) will search backwards (forwards) in history
# for all lines that begin with everything up to the cursor.
# However, META-P (META-N) will do the same but only for the first word on the
# current line.
bindkey '\ep' history-beginning-search-backward
bindkey '\en' history-beginning-search-forward
bindkey '\M-p' history-beginning-search-backward
bindkey '\M-n' history-beginning-search-forward

# Increment/decrement numbers with ^X^A / ^X^X, similar to Vim.
autoload -U increment-number  # in .zsh/functions/
zle -N increment-number
bindkey '^X^A' increment-number
bindkey -s '^X^X' '^[-^X^A'

# Cycle quoting on the current word with ALT-'.
autoload -U cycle-quotes  # in .zsh/functions/
zle -N cycle-quotes
bindkey "^['" cycle-quotes
bindkey "\\M-'" cycle-quotes

# Make ^V display a "^" while it is waiting for the next key, like vi does.
bindkey '^V' vi-quoted-insert


# ----------------------------------------------------------------------------
#                                   Options
# ----------------------------------------------------------------------------

# Options that I like; see zsh_15.html
setopt append_history
#setopt auto_cd
setopt auto_push_d
setopt c_bases
setopt extended_glob
setopt hist_ignore_all_dups
setopt list_packed
setopt magic_equal_subst
setopt no_clobber
setopt no_equals
setopt no_nomatch
#setopt null_glob
setopt push_d_ignore_dups
setopt rm_star_silent

HISTFILE=~/.zhistfile
HISTSIZE=100000
SAVEHIST=100000

WORDCHARS='*?_-.[]~&;!#$%^(){}<>'


# ----------------------------------------------------------------------------
#                                  Completion
# ----------------------------------------------------------------------------

# Turn on completion
autoload -U compinit
compinit -u
autoload -U bashcompinit
bashcompinit

# Use our version of git-completion.bash, not the one in /etc.
zstyle ':completion:*:*:git:*' script ~/.zsh/functions/git-completion.bash

# Turn on caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Set up color completion lists
if which dircolors >/dev/null 2>/dev/null; then
  if [[ -e ~/.dir_colors ]]; then
    eval `dircolors -b ~/.dir_colors`
  else
    eval `dircolors -b`
  fi
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# Complete git revision (object) IDs with ALT-r (ALT-R)
# TODO

# Use ._- as separators in completion.  For example, type "cd /etc/c.w<TAB>"
# and it will complete to "cd /etc/cron.weekly".
# zstyle ':completion:*' matcher-list '' 'r:|[._-]=** r:|=**'

# Ignore foo.exe when foo exists
#zstyle ':completion::complete:-command-:*' ignored-patterns '*.(#i)exe'
#zstyle ':completion:*' completer _complete _ignored

## Completion for ssh and scp
zstyle ':completion:*:scp:*' tag-order \
        'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:scp:*' group-order \
        users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
        users 'hosts:-host hosts:-domain:domain hosts:-ipaddr:IP\ address *'
zstyle ':completion:*:ssh:*' group-order \
        hosts-domain hosts-host users hosts-ipaddr

zstyle ':completion:*:(ssh|scp):*:hosts-host' ignored-patterns \
        '*.*' loopback localhost
zstyle ':completion:*:(ssh|scp):*:hosts-domain' ignored-patterns \
        '<->.<->.<->.<->' '^*.*' '*@*'
zstyle ':completion:*:(ssh|scp):*:hosts-ipaddr' ignored-patterns \
        '^<->.<->.<->.<->' '127.0.0.<->'
zstyle ':completion:*:(ssh|scp):*:users' ignored-patterns \
        adm bin daemon halt lp named shutdown sync

zstyle -e ':completion:*:(ssh|scp):*' hosts 'reply=(
        ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) \
                        /dev/null)"}%%[# ]*}//,/ }
        ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
        )'

# Automatically escape globbing characters on the server side.
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
zstyle -e :urlglobber url-other-schema \
  '[[ $words[1] == scp ]] && reply=("*") || reply=(http https ftp)'

# Ignore words already completed for some commands
zstyle ':completion:*:(rm|ls|cp|mv):*' ignore-line true

# SSH / SCP Completion
# TODO


# ----------------------------------------------------------------------------
#                                    Prompt
# ----------------------------------------------------------------------------
#
# The prompt looks like this, without hostname if on $MY_MACHINE.
# ……………………………………………………………………………………………………………………………………………………………… ~/non/git/dir …
# ▶ cd ~/git/repo/subdir                                              hostname
# …………………………………………………………………………………………………………………………… (master) ~/git/repo/subdir …
# ▶                                                                   hostname

# We need to enable the following so $VARIABLES are expanded in the prompt.
setopt prompt_subst

# Load git's default prompt support.
if [[ -e ~/.zsh/functions/git-prompt.sh ]]; then
  source ~/.zsh/functions/git-prompt.sh
else
  __git_ps1() {}
fi

# Git branch information to display, or empty.
PROMPT_GIT_NOCOLOR=
PROMPT_GIT=

# Length of PROMPT_GIT_NOCOLOR.
PROMPT_GIT_WIDTH=0

# This is the data that is shown in the prompt.  Its printable length (i.e.
# ignoring ANSI color codes) must be no longer than PROMPT_MAX_LENGTH.
#   %~
#     Prints $PWD, with $HOME replaced by ~.
#   %$N<$REPL<$STRING%<<
#     Truncates $STRING to length $N, replacing the cut-off characters on
#     the left (if any) with $REPL.  We delay the expansion of $N until
#     prompt-time.
PROMPT_DATA_NOCOLOR="%\$((PROMPT_MAX_WIDTH-PROMPT_GIT_WIDTH))<..<%~%<<"

# This must always be the same length as PROMPT_DATA with all non-printable
# chraracters (e.g. color codes) removed.  We expand PROMPT_DATA_NOCOLOR now
# because prompt-time expansion can only go one level deep.
#   %22F...%f
#     Highlights ... with color 22 (dark green).
PROMPT_DATA="\$PROMPT_GIT%22F$PROMPT_DATA_NOCOLOR%f"

# Length of PROMPT_DATA_NOCOLOR, computed at prompt-time.
#   ${(%%)FOO}
#     Performs full prompt expansion of $FOO.
#   ${#BAR}
#     Computes the number of characters in $BAR.
PROMPT_DATA_WIDTH="(\${#\${(%%)PROMPT_DATA_NOCOLOR}}+PROMPT_GIT_WIDTH)"

# Maximum width of PROMPT_DATA_NOCOLOR.
#   9 = 5 (always display at least this many fill characters on the left)
#     + 2 (spaces surrounding PROMPT_DATA)
#     + 1 (the right-hand '…')
#     + 1 (space at end)
PROMPT_MAX_WIDTH="COLUMNS-9"

# Same as above, but ignoring the minimum fill width.
PROMPT_FILL_MAX_WIDTH="COLUMNS-4"

# The horizontal rule; size is computed dynamically at prompt-time.  Note that
# we expand the values inside $(()) now.
#   ${(r.$LENGTH..$FILL.):-}
#     Repeats $FILL for $LENGTH characters.
#   5
#     Same value used in computation of $PROMPT_MAX_WIDTH
PROMPT_FILL="\${(r.\$((${PROMPT_FILL_MAX_WIDTH}-$PROMPT_DATA_WIDTH))..….):-}"

# The main prompt.  Note that it contians an embedded newline.
#   %94F...$f
#     Highlight ... with color 94 (orange).
# Useful symbols for future use:
#   ┌┤└─┘├┐┄ … ▶
PS1="%94F$PROMPT_FILL%f $PROMPT_DATA %94F…%f
%94F▶%f "

# The secondary prompt.  This is just the default prompt with color.
PS2='%94F%_>%f '

# The select prompt.  This is just the default prompt with color.
PS3='%94F?#%f '

# The debug prompt.  This is just the default prompt with color.
PS4='%94F+%N:%i>%f '

# The main right-hand prompt.  We set it to the current hostname if we're not
# on MY_MACHINE.
if [[ "$THIS_MACHINE" != "$MY_MACHINE" ]]; then
  RPS1="%22F$THIS_MACHINE%f"
else
  RPS1=
fi

# Set PROMPT_GIT, PROMPT_GIT_NOCOLOR, and PROMPT_GIT_WIDTH.
update_prompt_git() {
  local branch
  branch="$(__git_ps1 '%s')"
  if [[ -n $branch ]]; then
    PROMPT_GIT_NOCOLOR="($branch) "
    PROMPT_GIT="%94F(%30F$branch%94F)%f "
  else
    PROMPT_GIT_NOCOLOR=
    PROMPT_GIT=
  fi
  PROMPT_GIT_WIDTH="${#PROMPT_GIT_NOCOLOR}"
}
precmd_functions+=update_prompt_git


# ----------------------------------------------------------------------------
#                                 Window Title
# ----------------------------------------------------------------------------

# Create a term-specific set_title function.
case $TERM in
  cygwin|xterm*|rxvt*|(E|a|k)term|screen*)
    set_title() { printf "\e]0;%s\a" "$*" }
    ;;
  *)
    set_title() {}
esac

# Set the xterm title bar to "$PWD @ $THIS_MACHINE", with $PWD truncated to
# show only the rightmost 70 characters.
if [[ "$THIS_MACHINE" != "$MY_MACHINE" ]]; then
  TITLE_SUFFIX=" @ $THIS_MACHINE"
else
  TITLE_SUFFIX=
fi
precmd_title() {
  local title="%70<..<%~%<<"
  title="${(%)title}"     # Expand prompt % sequences.
  set_title "$title$TITLE_SUFFIX"
}

# Set the xterm title bar to "$COMMAND @ $THIS_MACHINE", where $COMMAND is the
# current command being executed, with $0 replaced with its basename and the
# whole command being truncated to the leftmost 70 characters.
preexec_title() {
  local -a args
  local cmd
  emulate -L zsh          # Make sure that no options screw up this function.
  args=(${(z)1})          # Shell-split the command line into an array.
  args[1]="$args[1]:t"    # Take the basename of the executable.
  if [[ $args[1] == sudo ]]; then
    args[2]="$args[2]:t"  # Do the same for the executable that sudo will run.
  fi
  cmd="$args"             # Join the arguments with a space.
  cmd="${(V)cmd}"         # Make special characters printable (e.g. \033 -> ^[)
  if [[ ${#cmd} -gt 70 ]]; then
    cmd="${cmd:0:68}.."   # Truncate to 70 characters, including the ".."
  fi
  set_title "$cmd$TITLE_SUFFIX"
}

preexec_functions+=preexec_title
precmd_functions+=precmd_title


# ----------------------------------------------------------------------------
#                     Machine-specific Configuration (end)
# ----------------------------------------------------------------------------

[[ -r ~/.zsh/rc-private-bottom.zsh ]] && source ~/.zsh/rc-private-bottom.zsh
