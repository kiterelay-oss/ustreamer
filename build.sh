#!/usr/bin/env bash
# Reproduce the exact modified uStreamer that KiteRelay ships:
# upstream pikvm/ustreamer @ v6.61 + the patch in ./patches. Also copies the
# upstream GPLv3 license text (COPYING) into this directory so the corresponding
# source is self-contained.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
WORK="${1:-$HERE/build}"
rm -rf "$WORK"; mkdir -p "$WORK"; cd "$WORK"

git clone https://github.com/pikvm/ustreamer.git
cd ustreamer
git checkout v6.61
for p in "$HERE"/patches/*.patch; do
  echo "applying $(basename "$p")"
  patch -p1 < "$p"
done
# keep a verbatim copy of uStreamer's GPLv3 license alongside our patch
cp -f LICENSE "$HERE/COPYING" 2>/dev/null || cp -f COPYING "$HERE/COPYING" 2>/dev/null || true

make WITH_JANUS=1
echo
echo "built: $WORK/ustreamer/src/ustreamer.bin"
echo "install: sudo install -m755 src/ustreamer.bin /usr/local/bin/ustreamer"
