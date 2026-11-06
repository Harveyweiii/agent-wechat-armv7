# 在玩客云上部署 Agent WeChat

## 1. 确认设备并下载

在目标玩客云执行 `uname -m`、`dpkg --print-architecture` 和 `getconf GNU_LIBC_VERSION`。这个包要求 `armv7l`、`armhf` 和 glibc 2.28 或更新版本。用 `grep -m 1 '^Features' /proc/cpuinfo` 确认有 `neon` 和 `vfpv4`，再确认系统使用 systemd。

在有 Git 的电脑或玩客云上获取固定版本。若在电脑上下载，把目录复制到玩客云再执行安装命令。

```bash
git clone --branch v1.5.1-armv7.1 --depth 1 \
  https://github.com/Harveyweiii/agent-wechat-armv7.git
cd agent-wechat-armv7
(cd dist && sha256sum -c SHA256SUMS.txt)
```

## 2. 安装和验证

以下命令在目标设备的 root 终端中执行，适用于首次安装。先检查 `/usr/local/bin/wx`、`/etc/systemd/system/agent-wechat.service` 和本机 TCP 6174 端口。如果已存在部署，先查清服务归属并备份当前程序、服务配置和数据，确认升级范围后再替换。

媒体处理需要 `ffmpeg` 和同包的 `ffprobe`。要使用本地音频，再安装 `libpulse0`。Debian 10 的普通镜像可能已移除 Buster，遇到这种情况请使用可信的 Debian 归档源；可通过一次性的 APT 源配置安装所需包，保留现有全局源。

```bash
getent passwd agent-wechat >/dev/null || \
  useradd --system --user-group --create-home \
    --home-dir /var/lib/agent-wechat --shell /usr/sbin/nologin agent-wechat
install -d -m 0700 -o agent-wechat -g agent-wechat /var/lib/agent-wechat
install -m 0755 dist/wx-v1.5.1-onecloud-armv7 /usr/local/bin/wx
install -m 0644 ports/onecloud-armv7/agent-wechat.service \
  /etc/systemd/system/agent-wechat.service
wx version
systemctl daemon-reload
systemctl enable --now agent-wechat.service
curl --fail --silent --show-error --retry 8 --retry-connrefused \
  --retry-delay 1 --max-time 3 http://127.0.0.1:6174/health
ss -ltn 'sport = :6174'
```

健康接口应返回 `{"status":"ok"}`，监听地址应为 `127.0.0.1:6174`。如果启动失败，用 `journalctl -u agent-wechat.service -n 50 --no-pager` 检查错误。账号数据保存在 `/var/lib/agent-wechat`，升级或排障时应保留该目录。

## 3. 扫码登录

在有交互终端的 SSH 会话里执行。先列出账号，只有空列表时才创建 `me`。手机用户亲自扫码并确认。

```bash
runuser -u agent-wechat -- env HOME=/var/lib/agent-wechat wx accounts list
# 仅在没有账号时执行下一行。
runuser -u agent-wechat -- env HOME=/var/lib/agent-wechat wx accounts create --alias me
runuser -u agent-wechat -- env HOME=/var/lib/agent-wechat wx auth login
runuser -u agent-wechat -- env HOME=/var/lib/agent-wechat wx accounts list
```

用账号状态中的已认证和在线字段确认登录结果。不要在公开日志、仓库或聊天里粘贴二维码、支付验证信息、API 令牌或账号资料。
