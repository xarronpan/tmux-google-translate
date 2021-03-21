#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${CURRENT_DIR}/scripts/helpers.sh"

generate_cmd() {
  local cmd="$1"

  if cmd_exists "$cmd"; then
    cmd="$(cmd_path "trans")"
    echo "xargs -I {} tmux split-window -l 10 '$cmd :zh \"{}\" > /dev/null | less -R'"
  else
    display_msg "Please make sure translate-shell is installed."
  fi
}

readonly translate_shell_key="$(get_tmux_option "@translate-shell-key" "x")"
readonly translate_copy_key=$(get_tmux_option "@translate-copy-key" "X")
readonly translate_cmd="$(generate_cmd "trans")"

# copy mode
tmux bind-key -T copy-mode-vi "$translate_copy_key" send -X copy-pipe "$translate_cmd"
# normal
tmux bind-key "$translate_shell_key" split-window -l 10 "$(cmd_path "trans") -shell"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=sh sw=2 ts=2 et
