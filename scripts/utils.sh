#!/usr/bin/env sh

set -e -o pipefail

dir_has_file() {
  dir="$1"; shift;
  for arg in ${@}; do
    if [ -e "$dir/$arg" ]; then
      return 0;
    fi
  done
  return 1;
}

find_closest() {
  init_dir="${1:-"$PWD"}"; shift;
  dir="$init_dir";
  while [ "$dir" != "" ] && [ "$dir" != "." ]; do
    if [ "$dir" == "/" ]; then
      dir="$init_dir"
      break;
    fi
    if dir_has_file "$dir" "$@"; then
      break;
    fi
    dir=$(dirname "$dir");
  done
  if [ -f "$dir" ]; then
    dirname "$dir";
  else
    echo "$dir";
  fi
}

cmd="$1"; shift;
case "$cmd" in
  find_closest) find_closest "$@" ;;
esac
