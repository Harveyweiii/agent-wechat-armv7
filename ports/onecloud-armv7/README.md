# OneCloud ARMv7 build

This port builds the upstream `wx` daemon and CLI for the OneCloud S805 (Cortex-A5) running Armbian 20.12 / Debian 10. It targets ARMv7 hard-float and glibc 2.28. The upstream binary releases target x64 and ARM64 with a newer glibc, so they cannot run on this system. The source patch also keeps normal-video encoding usable with Debian 10's FFmpeg 4.1.

## Prepare the source

Run this from the root of this distribution checkout. It keeps the upstream source at the exact revision used for the published binary.

```bash
distribution="$(pwd)"
git clone https://github.com/thisnick/agent-wechat.git agent-wechat-upstream
cd agent-wechat-upstream
git checkout --detach 39af1eec84f4763e1257406f8c5fb848b31d82e9
git apply --check "$distribution/patches/onecloud-armv7.patch"
git apply "$distribution/patches/onecloud-armv7.patch"
mkdir -p ports
cp -a "$distribution/ports/onecloud-armv7" ports/
```

## Build

Use an x64 Linux builder with Rust 1.93.1, the `armv7-unknown-linux-gnueabihf` Rust target, `gcc-arm-linux-gnueabihf`, CMake, Perl and a Debian 10 armhf sysroot that includes `libc6-dev` and `linux-libc-dev`. Prepare an empty sysroot once:

```bash
sudo apt-get install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf cmake debootstrap pkg-config perl make python3 debian-archive-keyring
rustup toolchain install 1.93.1 --profile minimal --component rustfmt --component clippy
rustup target add armv7-unknown-linux-gnueabihf --toolchain 1.93.1
export ONECLOUD_BUILD_ROOT="$HOME/build/agent-wechat-armv7"
mkdir -p "$ONECLOUD_BUILD_ROOT"
sudo debootstrap --foreign --variant=minbase --include=libc6-dev,linux-libc-dev \
  --arch=armhf buster "$ONECLOUD_BUILD_ROOT/sysroot" \
  https://archive.debian.org/debian/
```

If the archive signature cannot be verified on your builder, use a separately verified Debian 10 armhf sysroot containing the same development packages and set `ONECLOUD_SYSROOT` to its path.

Then build:

```bash
sudo python3 ports/onecloud-armv7/fix-sysroot-links.py "${ONECLOUD_SYSROOT:-$ONECLOUD_BUILD_ROOT/sysroot}"
bash ports/onecloud-armv7/build.sh
```

The output is `packages/native-client-rust/target/armv7-unknown-linux-gnueabihf/release/wx`. The build script enables the S805's NEON/VFPv4 features for native C dependencies and uses the Debian 10 sysroot for linking. `cargo-config.toml` points Cargo at the rsproxy mirror for builders where crates.io is slow; it does not change application behavior.

For service setup and login, follow the [deployment guide](../../DEPLOY.md) in the distribution checkout.
