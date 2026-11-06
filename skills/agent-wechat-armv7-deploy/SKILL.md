---
name: agent-wechat-armv7-deploy
description: Deploy, upgrade, or diagnose the OneCloud ARMv7 build of Agent WeChat on a Debian or Armbian host. Use when the user asks to install the Harveyweiii ARMv7 artifact, manage its systemd service, or bring its WeChat account online. Use the upstream project's instructions for other architectures.
---

# Deploy Agent WeChat on OneCloud ARMv7

Use the [deployment runbook](../../DEPLOY.md) from the release checkout. If this skill was installed separately, retrieve the runbook and artifacts from the fixed [v1.5.1-armv7.1 tag](https://github.com/Harveyweiii/agent-wechat-armv7/tree/v1.5.1-armv7.1) of the distribution repository.

1. Confirm the user's target host and SSH identity. Collect `uname -m`, `dpkg --print-architecture`, glibc version, CPU features, systemd status, and free disk space. The supported artifact requires ARMv7 hard-float, NEON, VFPv4, and glibc 2.28 or newer. Stop before installation if the target or binary checksum does not match.
2. Detect any existing `wx` binary, service, or port 6174 listener. Use the runbook for a fresh installation. For an authorized upgrade, record the existing service and binary paths, preserve the data directory, and back up the files being replaced. Restore the previous files and service if health checks fail after the upgrade.
3. Install the verified binary and start the service as the dedicated `agent-wechat` user. Keep the API on loopback unless the user requests remote access. Verify the version, listener, and health endpoint. On Debian 10, install media dependencies from a trusted archive if needed and keep the host's existing APT source configuration.
4. Start login only when requested. Run account commands as the service user with `HOME=/var/lib/agent-wechat`. Reuse an existing account entry. Have the user scan and confirm on their phone, then verify authentication and connection status. If WeChat requests a separate identity or payment check, leave that step to the user in WeChat.
5. Report the host, service status, health result, and login status separately. Verify message delivery only when authorized, with an explicitly identified recipient such as File Transfer. For build failures or custom binaries, use the repository's [build notes](../../ports/onecloud-armv7/README.md).

Keep credentials, QR images, account data, and API tokens out of logs and deployment artifacts.
