#!/usr/bin/env sh

set -e -o pipefail

logger_path="$HOME/nixos/extras/notes/logger"

journal() {
  capture_and_edit_date_log journal << EOF
* $(date +%r)
New entry
EOF
}

record() {
  capture_and_edit_date_log record << EOF
* $(date +%r)
** Situation
-
** Thoughts
-
** Feelings
-
** Actions
-
EOF
}

link() { capture_link "$@"; }

capture_and_edit_date_log() {
  path="${logger_path}/$1/$(date +%F).org";
  mkdir -p "${logger_path}/$1";
  cat >> "$path";
  echo -e "" >> "$path";
  edit "$path";
}

capture_link() {
  [ $# -gt 0 ] || (echo "Please specify link to capture"; exit 1)
  link="$1"
  category="${2:-default}"
  mkdir -p "${logger_path}/links";
  path="${logger_path}/links/$category.org";
  echo "[[$link]]" >> "$path";
  notify-send "Captured $link in $category"
}

edit() {
  setsid -f sh -c "exec ${EDITOR:-"${VISUAL:-kak}"} $@";
}

mkdir -p "$logger_path";
cmd="$1"; shift 1;
case "$cmd" in
  journal) journal ;;
  record) record ;;
  link) link "$@" ;;
esac
