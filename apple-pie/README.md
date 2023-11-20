# Apple Pie - Home Raspberry Pi Server

Apple pie is my cute nickname for my raspberri pi server running at home. Theres some information about this server and it's setup that I'd love to remember. That is why this doc exists. 

## Technology
- K3s due to superior arm support
- Raspberry pi
- Want to use cloudflare tunneling to connect to outside internet

## Reboot Resilience
By default when K3s is installed via it's install script, it will install itself as a systemd service which can be enabled for bootup.

```bash
# Check if k3s is installed as a service:
systemctl status k3s
```

```bash
# Enable k3s to come up on startup
systemctl enable k3s
```

## SSH into server
No password is available, you must use the p1 private key which is stored someplace you can get to.