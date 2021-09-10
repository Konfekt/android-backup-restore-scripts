#!/usr/bin/env bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace

cwd="$(cd "$(dirname "${BASH_SOURCE[0]:-${0}}")" >/dev/null 2>&1 && pwd)"
destination_dir="$cwd/packages" && mkdir -p "$destination_dir"

# From https://stackoverflow.com/a/43442399
# To identify the package name: adb shell pm list packages
# Example: pull-apk com.android.contacts

package="$1"
destination_apk="${destination_dir}/${package}.apk" && touch "$destination_apk"
destination_ab="${destination_dir}/${package}.ab" && touch "$destination_ab"

if [ -z "$package" ]; then
    echo "You must pass a package name!"
    echo "Ex.: pull-apk \"com.android.contacts\""
    return 1
fi

if ! adb shell pm list packages | grep -q "$package" ; then
    echo "You typed an invalid package name!"
    return 1
fi

package_path="$(adb shell pm path $package | sed -e 's/package://g' | tr '\n' ' ' | tr -d '[:space:]')"

adb -d pull -p "${package_path}" "${destination_apk}"
adb -d backup -f "${destination_ab}" -ab -obb "${package}"
echo -e "\nbackup files of $package saved"
