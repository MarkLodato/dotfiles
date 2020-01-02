# ----------------------------------------------------------------------------
#                        Machine-specific Configuration
# ----------------------------------------------------------------------------

[[ -r ~/.zsh/rc-private-top.zsh ]] && source ~/.zsh/rc-private-top.zsh

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
  if which dbus-uuidgen > /dev/null; then
    if [[ -f ~/.dbus/session-bus/$(dbus-uuidgen --get)-0 ]]; then
      source ~/.dbus/session-bus/$(dbus-uuidgen --get)-0
      export DBUS_SESSION_BUS_ADDRESS
    fi
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

# Make ALT-H work with git.
autoload -U run-help
autoload -U run-help-git

# The LC_COLLATE=C sorts using ASCII, so uppercase comes before lowercase.
if ls --color=auto -d / &>/dev/null; then
  alias ls='LC_COLLATE=C ls --color=auto'  # GNU coreutils
else
  alias ls='LC_COLLATE=C ls -G'  # BSD / Mac OS X
fi
alias lsa='ls -A'
alias ll='ls -lh'
alias lla='ls -la'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias diff='diff -u'
alias grep='grep --color=auto'
alias ag='ag --smart-case --pager=less'
alias gdiff='git diff --no-index --no-prefix'
alias gdiffw='git diff --no-index --no-prefix --color-words'
alias ggrep='git grep --no-index'
alias chrome='google-chrome'
alias :e='vim'
if ! which ack &>/dev/null && which ack-grep &>/dev/null; then
  alias ack=ack-grep
fi

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

# `sum` prints the sum of the numbers in the first column.
function sum {
  awk '{ sum += $1 } END { print sum }' "$@"
}

# `joinlines` joins all of the lines of stdin with the given string.
function joinlines {
  [[ $# -ne 1 ]] && { echo "USAGE: joinlines SEP" >&2; return 1 }
  local sep line
  # The test allows us to read the last line if it does not end in a newline.
  while read -r line || [[ -n $line ]]; do
    # If I ever feel like parsing options:
    # [[ $ignore_blanks -eq 0 && -z $line ]] && continue
    printf '%s%s' "$sep" "$line"
    # Do not print the separator before the first element.
    sep="$1"
  done
  printf '\n'
}

# C-escape the positional arguments, printing the results one per line.
# If no arguments are given, C-escape standard input.
function c_escape {
  local script='s/([\\"'\''])/\\\1/g; s/\n/\\n/g'
  if [[ $# -eq 0 ]]; then
    perl -pe "$script"
    echo
  else
    while [[ $# -gt 0 ]]; do
      echo -n "$1" | perl -pe "$script"
      echo
      shift
    done
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
# instead put the git directory in a different location and use this "gd"
# alias to manage dotfiles.
if [[ -e ~/.dotfiles.git && ! -e ~/.dotfiles/.git ]]; then
  alias gd='git --git-dir="$HOME/.dotfiles.git" --work-tree="$HOME"'
else
  alias gd='git --git-dir="$HOME/.dotfiles/.git" --work-tree="$HOME"'
fi


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

# Make CTRL-r search use a pattern rather than an exact match.
bindkey '^R' history-incremental-pattern-search-backward

# Make CTRL-f cycle backwards during a CTRL-r search.
bindkey -M isearch '^F' history-incremental-search-forward

# Find home, insert, delete, and end.
bindkey '\e[1~' beginning-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\e[2~' overwrite-mode
bindkey '\e[3~' delete-char
bindkey '\e[4~' end-of-line
bindkey '\e[8~' end-of-line

# Mac command-arrow keys (in Secure Shell plugin, at least.)
# Cmd-Up (\e\e[A) and Cmd-Down (\e\e[B) are unbound.
bindkey '\e\e[C' end-of-line        # Cmd-Right
bindkey '\e\e[D' beginning-of-line  # Cmd-Left

# Make CTRL-U kill to the beginning of the line (like bash), rather than the
# whole line.
bindkey '^U' backward-kill-line

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

# Expand aliases and $PATH for the the word under the cursor with ^X^I (^X tab).
autoload -U expand-last-word
zle -N expand-last-word
bindkey '^X^I' expand-last-word

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
# The prompt looks like this, without hostname if PROMPT_SHOW_HOSTNAME is 0.
# ……………………………………………………………………………………………………………………………………………………………… ~/non/git/dir …
# ▶ cd ~/git/repo/subdir                                              hostname
# …………………………………………………………………………………………………………………………… (master) ~/git/repo/subdir …
# ▶                                                                   hostname
#
# Naming convention used below:
#                                                 ┌"data"──────────────────┐
# ┌"fill" ──────────────────────────────────────┐ ┌"git"─┐ ┌"path"─────────┐
# …………………………………………………………………………………………………………………………… (master) ~/git/repo/subdir …

# We need to enable the following so $VARIABLES are expanded in the prompt.
setopt prompt_subst

# Load git's default prompt support.
if [[ -e ~/.zsh/functions/git-prompt.sh ]]; then
  source ~/.zsh/functions/git-prompt.sh
else
  __git_ps1() {}
fi

# If 1, show the hostname in the prompt. Only set the default if it is not
# already set.
if (( ${+SSH_CLIENT} )); then
  : ${PROMPT_SHOW_HOSTNAME:=1}
else
  : ${PROMPT_SHOW_HOSTNAME:=0}
fi

# Git branch information to display, or empty.
PROMPT_GIT_NOCOLOR=
PROMPT_GIT=

# Length of PROMPT_GIT_NOCOLOR.
PROMPT_GIT_WIDTH=0

# The value shown in the "path" portion of the prompt, before color and
# truncation.
#   %~
#     Prints $PWD, with $HOME replaced by ~.
PROMPT_PATH="%~"

# The truncated value shown in the "path" portion of the prompt, before color.
#   %$N<$REPL<$STRING%<<
#     Truncates $STRING to length $N, replacing the cut-off characters on
#     the left (if any) with $REPL.  We delay the expansion of $N until
#     prompt-time.
PROMPT_PATH_TRUNC="%\$((PROMPT_DATA_MAX_WIDTH_EXPR-PROMPT_GIT_WIDTH))<..<\$PROMPT_PATH%<<"

# The "data" portion of the prompt, with color.
#
# We expand PROMPT_PATH_TRUNC now because prompt-time expansion can only go one
# level deep.
#   %22F...%f
#     Highlights ... with color 22 (dark green).
PROMPT_DATA="\$PROMPT_GIT%22F$PROMPT_PATH_TRUNC%f"

# Math expression returning the length of PROMPT_DATA.
#   ${(%%)FOO}
#     Performs full prompt expansion of $FOO.
#   ${#BAR}
#     Computes the number of characters in $BAR.
PROMPT_DATA_WIDTH_EXPR="(\${#\${(%%)PROMPT_PATH_TRUNC}}+PROMPT_GIT_WIDTH)"

# Math expression returning the maximum width of PROMPT_DATA.
#   9 = 5 (always display at least this many fill characters on the left)
#     + 2 (spaces surrounding PROMPT_DATA)
#     + 1 (the right-hand '…')
#     + 1 (space at end)
PROMPT_DATA_MAX_WIDTH_EXPR="(COLUMNS-9)"

# Math expression returning the maximum width of PROMPT_FILL, i.e. when
# PROMPT_DATA is empty. Calculation is the same as PROMPT_DATA_MAX_WIDTH_EXPR
# but ignoring the minimum fill width.
PROMPT_FILL_MAX_WIDTH_EXPR="(COLUMNS-4)"

# The horizontal rule; size is computed dynamically at prompt-time. Note that
# we expand the $*_WIDTH_EXPR values now but the value will still be computed
# at prompt-time.
#   ${(r.$LENGTH..$FILL.):-}
#     Repeats $FILL for $LENGTH characters.
PROMPT_FILL="\${(r.\$((${PROMPT_FILL_MAX_WIDTH_EXPR}-$PROMPT_DATA_WIDTH_EXPR))..….):-}"

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

# The main right-hand prompt.
if (( $PROMPT_SHOW_HOSTNAME )); then
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
if (( $PROMPT_SHOW_HOSTNAME )); then
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
#                               Google Cloud SDK
# ----------------------------------------------------------------------------

if [[ -r $HOME/p/google-cloud-sdk/completion.zsh.inc ]]; then
  source $HOME/p/google-cloud-sdk/completion.zsh.inc
fi
if [[ -r $HOME/p/google-cloud-sdk/path.zsh.inc ]]; then
  source $HOME/p/google-cloud-sdk/path.zsh.inc
fi


# ----------------------------------------------------------------------------
#                     Machine-specific Configuration (end)
# ----------------------------------------------------------------------------

[[ -r ~/.zsh/rc-private-bottom.zsh ]] && source ~/.zsh/rc-private-bottom.zsh
