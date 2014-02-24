export LESS="-FRX"
export PATH="$HOME/local/bin:$HOME/p/scripts:$HOME/personal/scripts:$PATH"

if [[ $TERM == xterm ]]; then
    case "$COLORTERM" in
        gnome-terminal) export TERM=xterm-256color ;;
    esac
fi
