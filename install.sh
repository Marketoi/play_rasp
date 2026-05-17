#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Copy .env.example to /etc/kiosk.env if it does not already exist
if [ ! -f /etc/kiosk.env ]; then
  sudo cp "$REPO_DIR/.env.example" /etc/kiosk.env
  echo "Created /etc/kiosk.env"
  echo "Edit it with: sudo nano /etc/kiosk.env"
fi

# Install kiosk-browser
sudo cp "$REPO_DIR/scripts/kiosk-browser" /usr/local/bin/kiosk-browser
sudo chmod +x /usr/local/bin/kiosk-browser

echo "Installed /usr/local/bin/kiosk-browser"
echo "Configuration file: /etc/kiosk.env"

# Configure LXDE autostart for Raspberry Pi OS (rpd-x session)
sudo tee /etc/xdg/lxsession/rpd-x/autostart >/dev/null <<'EOF'
@lxpanel-pi
@pcmanfm-pi
@xscreensaver -no-splash

# Disable screen blanking and power saving
@xset s off
@xset -dpms
@xset s noblank

# Hide mouse cursor
@unclutter -idle 0 -root

# Launch Chromium kiosk
@/usr/local/bin/kiosk-browser
EOF

echo "Configured /etc/xdg/lxsession/rpd-x/autostart"