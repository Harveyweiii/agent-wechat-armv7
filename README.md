# Agent WeChat for OneCloud ARMv7

这是 [Agent WeChat 1.5.1](https://github.com/thisnick/agent-wechat/tree/39af1eec84f4763e1257406f8c5fb848b31d82e9) 的玩客云适配包。预编译的 `wx` 在 OneCloud S805（Cortex-A5）、Armbian 20.12 / Debian 10 上通过了启动、健康检查和扫码登录验证。

| 文件 | 用途 |
| --- | --- |
| [wx-v1.5.1-onecloud-armv7](dist/wx-v1.5.1-onecloud-armv7) | Linux ARMv7 hard-float 可执行文件 |
| [SHA256SUMS.txt](dist/SHA256SUMS.txt) | 安装前校验 |
| [部署说明](DEPLOY.md) | 安装为 systemd 服务并扫码登录 |
| [部署 Skill](skills/agent-wechat-armv7-deploy/SKILL.md) | 供 Codex 复用的部署和排障流程 |
| [适配补丁](patches/onecloud-armv7.patch) | ARMv7 的 SILK C 实现与 FFmpeg 4.1 滤镜兼容 |
| [构建说明](ports/onecloud-armv7/README.md) | 使用 Debian 10 armhf sysroot 交叉编译 |

二进制的目标为 `armv7-unknown-linux-gnueabihf`，最高引用 `GLIBC_2.28`，要求 CPU 支持 NEON 和 VFPv4。FFmpeg 和 FFprobe 用于媒体处理，`libpulse0` 用于本地音频。许可证和第三方声明见 [LICENSE](LICENSE) 与 [notices](notices/)。
