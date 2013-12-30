export LESS="-FRX"
export PATH="$HOME/local/bin:$HOME/personal/scripts:$PATH"

if [[ $TERM == xterm && $COLORTERM == gnome-terminal ]]; then
  TERM=xterm-256color
fi
