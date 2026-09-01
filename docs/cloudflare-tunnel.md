# Cloudflare Tunnel

Homebrew installs and upgrades `cloudflared`, but the `home` tunnel runs as the
system LaunchDaemon `com.cloudflare.cloudflared` so it starts at boot. Do not run
`brew services start cloudflared`; that creates an unconfigured per-user service.

For a new machine, set `TUNNEL_TOKEN` from a secure source and install the
boot-time service:

```sh
sudo cloudflared service install "$TUNNEL_TOKEN"
unset TUNNEL_TOKEN
```

After upgrading `cloudflared`, restart the service and verify the tunnel:

```sh
sudo launchctl kickstart -k system/com.cloudflare.cloudflared
cloudflared tunnel info home
```

Keep the tunnel token and generated LaunchDaemon plist out of this repository.
