#!/usr/bin/env bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace

cwd="$(cd "$(dirname "${BASH_SOURCE[0]:-${0}}")" >/dev/null 2>&1 && pwd)"
[ $# -eq 0 ] && echo "useage: $0 <package-list-file>"

list="$(realpath "$1")"
# list="package-list.txt"
[ -f "$list" ] || echo "useage: $0 <package-list-file>; argument passed is not a file!"

destination_dir="$cwd/packages" && mkdir -p "$destination_dir"

# TMPFILE="$(mktemp -t --suffix=.SUFFIX backup_package_list_sh.XXXXXX)"
# trap "rm -f '$TMPFILE'" 0               # EXIT
# trap "rm -f '$TMPFILE'; exit 1" 2       # INT
# trap "rm -f '$TMPFILE'; exit 1" 1 15    # HUP TERM
# adb shell pm list packages > "$TMPFILE"
(
cd "$cwd" 
cat "$list" | while read -r  p; do
	# skip comments
	[[ $p =~ ^#.* ]] && continue
	# skip empty lines
	[ -z "$p" ] && continue
	echo "Backing up $p ..."
	# cat "$TMPFILE" | grep -q "$p" || continue
  . ./backup-package.sh "$p"
done
)

