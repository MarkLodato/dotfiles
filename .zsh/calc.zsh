#!/bin/zsh
# calculator in the shell

function calc() {
  local base
  if (( $# < 1 )); then
    echo "USAGE: $0 [-b <base>] <mathexpr>"
  else
    base=
    case "$1" in
      -h|-help|--help)
        echo "USAGE: $0 [-b <base>] <mathexpr>"
        return
        ;;
      -b)
        base="[#$2]"
        shift 2
        ;;
      -b*)
        base="[#${1:2}]"
        shift
        ;;
      *)
    esac
    echo $(( $base $* ))
  fi
}

function h2d() {
  if (( $# == 1 )); then
    echo "$(( 16#$1 ))"
  else
    for x in $@; do
      echo "0x$x\t$(( 16#$x ))"
    done
  fi
}

function d2h() {
  if (( $# == 1 )); then
    echo "$(( [#16] $1 ))"
  else
    for x in $@; do
      echo "$x\t$(( [#16] $x ))"
    done
  fi
}

function revbits_f() {
  print $(( [#16] (((($1*0x80200802)&0x884422110)*0x0101010101)>>32)&0xff ))
}

function revbits() {
  for x in $@; do
    revbits_f $((16#$x))
  done
}
