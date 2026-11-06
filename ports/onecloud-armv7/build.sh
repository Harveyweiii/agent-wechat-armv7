#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/../.." && pwd)
build_root=${ONECLOUD_BUILD_ROOT:-"$HOME/build/agent-wechat-armv7"}
export ONECLOUD_SYSROOT=${ONECLOUD_SYSROOT:-"$build_root/sysroot"}
export CARGO_HOME=${CARGO_HOME:-"$build_root/cargo-home"}
export PATH="$HOME/.cargo/bin:$PATH"
export CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER="$root/ports/onecloud-armv7/linker.sh"
export CC_armv7_unknown_linux_gnueabihf="$root/ports/onecloud-armv7/linker.sh"
export CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++
export AR_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-ar
export CFLAGS_armv7_unknown_linux_gnueabihf="-march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -DONECLOUD_DEBIAN10_SYSROOT=1"
export CARGO_BUILD_JOBS=${CARGO_BUILD_JOBS:-2}
export CARGO_PROFILE_RELEASE_STRIP=symbols
export PKG_CONFIG_ALLOW_CROSS=1
export PKG_CONFIG_SYSROOT_DIR="$ONECLOUD_SYSROOT"
export PKG_CONFIG_LIBDIR="$ONECLOUD_SYSROOT/usr/lib/arm-linux-gnueabihf/pkgconfig:$ONECLOUD_SYSROOT/usr/share/pkgconfig"

test -f "$ONECLOUD_SYSROOT/usr/lib/arm-linux-gnueabihf/crt1.o"
test -e "$ONECLOUD_SYSROOT/usr/lib/arm-linux-gnueabihf/libm.so"
mkdir -p "$CARGO_HOME"
if [[ ! -f "$CARGO_HOME/config.toml" ]]; then
  cp "$root/ports/onecloud-armv7/cargo-config.toml" "$CARGO_HOME/config.toml"
fi

cd "$root"
cargo +1.93.1 build \
  --manifest-path packages/native-client-rust/Cargo.toml \
  --release --locked --package wx-native \
  --target armv7-unknown-linux-gnueabihf
