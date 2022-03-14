blaze_or_bazel() {
  if [[ $PWD = */google3 || $PWD = */google3/* ]]; then
    echo blaze
  else
    echo bazel
  fi
}

# Useful tip: less `blaze_error_files`
blaze_error_files() {
  local master_log
  local blaze=$(blaze_or_bazel)
  master_log="$("$blaze" info master-log)" || return $?
  awk '$1 == "test" && $4 != "passed" {print $6}' "$master_log"
}

blaze_errors() {
  local file files
  files="$(blaze_error_files)" || return $?
  for file in "${(@f)files}"; do  # @f splits on newlines
    sed -n -r -e '
      # C++ gUnit EXPECT/ASSERT failures.
      /:[0-9]+: Failure$/,/^Stack trace/{s/^Stack trace.*//;p}

      # C++ gUnit failed tests.  Only print the line at the end of that test,
      # which has a time in parentheses at the end, and not the summary at the
      # bottom, which does not.  Also print a blank line after.
      /^\[  FAILED  \] .* \(.*\)/{G;p}

      # JUnit failed tests, up to the stack trace.
      /^[0-9]+\) /,/^\s+at /{s/^\s+at .*//;p}

      # Python failed tests.
      /^={70}/,/^Ran \S* tests in/p

      # C++ fatal errors
      /^F[0-9]{4} /,/[Ss]tack trace/{s/^.*[Ss]tack trace.*//;p}

      # gBash failing tests
      /^__________  Test .* running/,/^__________  Test .* (passed|failed)/{
        H
        # Print failing tests, stripping off the leading newline that H adds.
        /^__________  Test .* failed/{x;s/^\n//;p}
        # Clear the hold and pattern spaces at the end of the test
        /^__________  Test .* (passed|failed)/{s/.*//;x;d}
      }

      # Segmentation faults
      /^\*\*\* .* received by PID .* stack trace/p

      # Stack traces printed for segfaults and C++ fatal errors
      /^    @/p

      # Print out the hold space if it is not empty.
      ${
        x
        s/./&/;t nonempty_hold
          d
        : nonempty_hold
          p
      }
      ' "$file"
  done | ~/.zsh/highlight_blaze_error_diffs.py | pager_if_tty
}
alias be=blaze_errors

blaze_test() {
  local rc=0
  local blaze=$(blaze_or_bazel)
  if (( $# > 0 )); then
    BLAZE_TEST_PREVIOUS_ARGS=( "$@" )
  elif [[ -z $BLAZE_TEST_PREVIOUS_ARGS ]]; then
    echo "USAGE: $0 <blaze-test-args>" >&2
    return 1
  else
    set -- "${BLAZE_TEST_PREVIOUS_ARGS[@]}"
    echo "Running: $blaze test $@"
  fi
  "$blaze" test "$@" || rc=$?
  (( rc == 3 )) && blaze_errors
  return $rc
}
alias t=blaze_test

