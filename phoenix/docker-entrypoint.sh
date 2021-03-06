#!/bin/sh

set -e

built_lock_file="/tmp/mix.lock"
current_lock_file="mix.lock"

function cp_built_lock_file() {
    cp "${built_lock_file}" "${current_lock_file}"
}

# This avoids your app mount clobbering the "real" mix.lock file that was
# created when building your dependencies using docker build.
if [ -f "${current_lock_file}" ]; then
    diff="$(diff "${built_lock_file}" "${current_lock_file}")"
    if [ "${diff}" != "" 2>/dev/null ]; then
        cp_built_lock_file
    fi
else
    cp_built_lock_file
fi

exec "$@"
