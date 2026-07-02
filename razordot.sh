#!/bin/sh

# POSIX sh exposes no call stack (there is no BASH_SOURCE / BASH_LINENO) and no
# ERR trap, so this reports the failing command's exit code rather than a
# multi-frame stack trace.
sh_error_handler() {
    exit_code=$?
    [ "$exit_code" -eq 0 ] && return 0
    printf 'Encountered an error (exit code %s).\n' "$exit_code" >&2
}

set_error_handler() {
    set -e
    trap sh_error_handler EXIT
}
