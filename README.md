# KiteRelay uStreamer (modified source)

This repository is the **complete corresponding source** for the modified
`uStreamer` binary that ships inside KiteRelay devices, provided to satisfy the
GNU General Public License v3 (GPLv3) under which uStreamer is licensed.

KiteRelay's build of uStreamer is **upstream [pikvm/ustreamer](https://github.com/pikvm/ustreamer)
at tag `v6.61`, plus one patch** in `patches/`. That patch is the only difference
from stock. Nothing else about uStreamer is changed.

## The change

`patches/0001-h264-min-qp-env.patch` makes the H.264 encoder's `MIN_QP` settable
at runtime through the environment variable `MB_H264_MIN_QP`. On the hardware
encoder KiteRelay uses, the `--h264-bitrate` target is effectively inert, so
`MIN_QP` is the only working per-frame bit ceiling; it caps the motion peak that
otherwise floods a slow uplink. If `MB_H264_MIN_QP` is absent or invalid, the
encoder falls back to upstream's hardcoded value (16), so a stock build still
runs correctly. See `patches/0001-h264-min-qp-env.patch` for the exact diff and
the rationale.

## Build it yourself

```sh
./build.sh          # clones v6.61, applies the patch, builds src/ustreamer.bin
```

or by hand:

```sh
git clone https://github.com/pikvm/ustreamer && cd ustreamer
git checkout v6.61
patch -p1 < ../patches/0001-h264-min-qp-env.patch
make WITH_JANUS=1
# result: src/ustreamer.bin  ->  install as /usr/local/bin/ustreamer
```

## License

uStreamer is licensed under the **GNU General Public License v3.0**. The full
license text is in `COPYING` (identical to the one in the upstream project). This
patch and this repository are offered under the same license.

Upstream project and its full history: https://github.com/pikvm/ustreamer
