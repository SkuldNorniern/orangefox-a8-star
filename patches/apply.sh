#!/bin/bash
# Apply patches/*.patch to OrangeFox bootable/recovery and add the maintainer picture.
# Re-runnable: patches that are already in are skipped.
set -e
SRC=${1:-~/fox_12.1}
R=$SRC/bootable/recovery
D=$(cd "$(dirname "$0")" && pwd)

for p in "$D"/*.patch; do
    if git -C "$R" apply --reverse --check "$p" 2>/dev/null; then
        echo "already applied: $(basename "$p")"
        continue
    fi
    git -C "$R" apply "$p"
    echo "applied: $(basename "$p")"
done

cp "$D/assets/maintainer.png" "$R/gui/theme/portrait_hdpi/images/Default/About/maintainer.png"
