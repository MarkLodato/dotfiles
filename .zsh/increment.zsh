# An improved version of incarg.  ^X^A / ^X^X operate like Vim's ^A / ^X,
# incrementing the closest decimal number under or to the right of the cursor,
# except that if there is no such number, falls back to looking to the left of
# the cursor, too.
#
# Usage:
#   source ~/.zsh/increment.zsh
#   bindkey '^X^A' increment-number
#   bindkey -s '^X^X' '^[-^X^A'
#
# TODO: Should I also move the cursor like Vim?
_increment-number() {
  setopt LOCAL_OPTIONS EXTENDED_GLOB
  local -a match mbegin mend
  if [[ $BUFFER[CURSOR+1] = [0-9] ]]; then
    local left=$((CURSOR+1)) right=$((CURSOR+1))
    [[ $LBUFFER = (*[^0-9]|)(#b)([0-9]##) ]] && left=$(( mbegin[1] ))
    [[ $RBUFFER = (#b)([0-9]##)* ]] && right=$(( ${#LBUFFER} + mend[1] ))
    BUFFER[left,right]=$(( BUFFER[left,right] + ${NUMERIC:-1} ))
  elif [[ $RBUFFER = [^0-9]#(#b)([0-9]##)* ]]; then
    RBUFFER[mbegin[1],mend[1]]=$(( match[1] + ${NUMERIC:-1} ))
  elif [[ $LBUFFER = (*[^0-9]|)(#b)([0-9]##)[^0-9]# ]]; then
    LBUFFER[mbegin[1],mend[1]]=$(( match[1] + ${NUMERIC:-1} ))
  fi
}
zle -N increment-number _increment-number
