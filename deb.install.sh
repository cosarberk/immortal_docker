#!/bin/bash

echo "📦 docker-watchdog.deb kuruluyor..."
sudo dpkg -i immortal_docker.deb

echo "🔄 systemd yeniden yükleniyor..."
sudo systemctl daemon-reload

echo "✅ Servis etkinleştiriliyor..."
sudo systemctl enable docker-watchdog

echo "🚀 Servis başlatılıyor..."
sudo systemctl start docker-watchdog

echo ""
echo "📊 Servis durumu:"
sudo systemctl status docker-watchdog --no-pager