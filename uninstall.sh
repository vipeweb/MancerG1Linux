#!/usr/bin/env bash
set -uo pipefail

[ "$(id -u)" -ne 0 ] || { echo "Não precisa de sudo, rode só ./uninstall.sh" >&2; exit 1; }

systemctl --user disable --now mancer-g1.service 2>/dev/null || true
sudo rm -f /usr/local/bin/mancer-g1-display /etc/udev/rules.d/70-mancer-g1.rules /etc/systemd/user/mancer-g1.service
sudo udevadm control --reload
systemctl --user daemon-reload

echo "Removido."
