export LESS="-FRX"
export PATH="$HOME/local/bin:$HOME/p/scripts:$HOME/personal/scripts:$PATH"

if [[ $TERM == xterm ]]; then
    case "$COLORTERM" in
        (gnome|xfce4)-terminal) export TERM=xterm-256color ;;
    esac
fi
