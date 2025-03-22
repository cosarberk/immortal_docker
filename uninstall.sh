#!/bin/bash

echo "🧹 docker-watchdog servisi durduruluyor..."
systemctl stop docker-watchdog
systemctl disable docker-watchdog
systemctl daemon-reload

echo "🗑️ Dosyalar siliniyor..."
rm -f /usr/local/bin/docker-watchdog.sh
rm -f /etc/systemd/system/docker-watchdog.service
rm -f /var/log/docker-watchdog.log

echo "📦 Paket kaldırılıyor..."
dpkg -r docker-watchdog 2>/dev/null || echo "(dpkg kaydı bulunamadı - elle kurulmuş olabilir)"

echo "✅ docker-watchdog tamamen kaldırıldı."