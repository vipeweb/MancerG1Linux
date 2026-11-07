#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

BIN=/usr/local/bin/mancer-g1-display
RULE=/etc/udev/rules.d/70-mancer-g1.rules
UNIT=/etc/systemd/user/mancer-g1.service

info() { printf '\e[1;32m==>\e[0m %s\n' "$*"; }
warn() { printf '\e[1;33m!!\e[0m %s\n' "$*"; }
die()  { printf '\e[1;31mErro:\e[0m %s\n' "$*" >&2; exit 1; }

[ "$(id -u)" -ne 0 ] || die "Não precisa de sudo, rode só ./install.sh"
command -v python3 >/dev/null   || die "Python 3 não encontrado. Instale e tente de novo."
command -v systemctl >/dev/null || die "Precisa de systemd."
command -v udevadm >/dev/null   || die "udevadm não encontrado."
for f in mancer-g1-display 70-mancer-g1.rules mancer-g1.service; do
    [ -f "$f" ] || die "Está faltando o arquivo $f."
done

info "Copiando arquivos (vai pedir sua senha)..."
sudo install -Dm755 mancer-g1-display "$BIN"
sudo install -Dm644 70-mancer-g1.rules "$RULE"
sudo install -Dm644 mancer-g1.service "$UNIT"

sudo udevadm control --reload
sudo udevadm trigger --subsystem-match=hidraw

info "Ligando o serviço..."
systemctl --user daemon-reload
systemctl --user enable mancer-g1.service
systemctl --user restart mancer-g1.service

sleep 3
if journalctl --user -u mancer-g1 -n 20 --no-pager 2>/dev/null | grep -q "conectado:"; then
    info "Pronto, o display já deve estar mostrando as informações."
else
    warn "Instalado, mas não achei o display."
    warn "Confira se o USB do cooler está ligado ou tire e coloque de novo."
fi
