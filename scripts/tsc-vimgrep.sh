#!/usr/bin/env sh

set -e -o pipefail

path="$1"

args="--noEmit --pretty false"
if [ -d "$path" ]; then
  args="$args -p $path"
elif [ -z "$path" ]; then
  args="$args -p ."
else
  args="$args $path"
fi

tsc="npx tsc"
if [ -f ./node_modules/.bin/tsc ]; then
  tsc="./node_modules/.bin/tsc";
fi

echo "running "$tsc" $args"
"$tsc" $args | sed -E 's/^([^(]+)\(([0-9]+),([0-9]+)\)\s*:\s*(.*)$/\1:\2:\3: \4/' || (echo "exited with $?"; exit $?)
echo "done"
