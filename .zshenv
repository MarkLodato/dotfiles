export LESS="-iFRXj5$"
export PATH="$HOME/local/bin:$HOME/p/scripts:$HOME/.local/bin:$PATH"

if [[ $TERM == xterm ]]; then
    case "$COLORTERM" in
        (gnome|xfce4)-terminal) export TERM=xterm-256color ;;
    esac
fi

# Disable Ubuntu's global compinit call in /etc/zsh/zshrc, which slows down
# shell startup time significantly.
skip_global_compinit=1
