tailscale:
sudo tailscale up
tailscale configure systray --enable-startup=systemd
systemctl --user daemon-reload
systemctl --user enable --now tailscale-systray
sudo tailscale set --operator=fer


