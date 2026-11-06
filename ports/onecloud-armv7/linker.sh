#!/bin/sh
set -eu

: "${ONECLOUD_SYSROOT:?set ONECLOUD_SYSROOT to the Debian 10 armhf sysroot}"
gcc_include=$(arm-linux-gnueabihf-gcc -print-file-name=include)

exec arm-linux-gnueabihf-gcc \
  --sysroot="$ONECLOUD_SYSROOT" \
  -nostdinc \
  -isystem "$gcc_include" \
  -isystem "$ONECLOUD_SYSROOT/usr/include/arm-linux-gnueabihf" \
  -isystem "$ONECLOUD_SYSROOT/usr/include" \
  -B"$ONECLOUD_SYSROOT/usr/lib/arm-linux-gnueabihf/" \
  -L"$ONECLOUD_SYSROOT/usr/lib/arm-linux-gnueabihf" \
  -L"$ONECLOUD_SYSROOT/lib/arm-linux-gnueabihf" \
  "$@"
