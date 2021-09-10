#!/usr/bin/env bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

scriptdir="$(cd "$(dirname "${BASH_SOURCE[${__b3bp_tmp_source_idx:-0}]}")" && pwd)"
cwd="$scriptdir"
destination_dir="$cwd/packages" && mkdir -p "$destination_dir"

[ $# -eq 0 ] && echo "useage: $0 <package-list-file>"

(
cd "$cwd" || exit 1
# list="package-list.txt"
list="$1"
[ -f "$1" ] || echo "useage: $0 <package-list-file>; argument passed is not a file!"
cat "$list" | while read -r  p; do
  # skip comments
  [[ $p =~ ^#.* ]] && continue
  # skip empty lines
  [ -z "$p" ] && continue
  adb -d install "./packages/$p.apk"
  adb -d restore "./packages/$p.ab"
done
)
