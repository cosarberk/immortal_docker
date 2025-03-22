#!/bin/bash

SERVICE_FILE="/etc/systemd/system/docker-watchdog.service"
SCRIPT_FILE="/usr/local/bin/docker-watchdog.sh"
LOG_FILE="/var/log/docker-watchdog.log"

echo "📦 Kurulum başlatılıyor..."

# Script dosyasını oluştur
echo "🔧 Script dosyası oluşturuluyor: $SCRIPT_FILE"
cat <<'EOF' > "$SCRIPT_FILE"
#!/bin/bash

LOGFILE="/var/log/docker-watchdog.log"

while true; do
  for cid in $(docker ps -a --filter "status=exited" -q); do
    name=$(docker inspect --format='{{.Name}}' "$cid" | cut -c2-)
    echo "[$(date)] Restarting container: $name ($cid)" >> "$LOGFILE"
    docker restart "$cid" >> "$LOGFILE" 2>&1
  done
  sleep 10
done
EOF

chmod +x "$SCRIPT_FILE"

# Log dosyasını oluştur
echo "📄 Log dosyası oluşturuluyor: $LOG_FILE"
touch "$LOG_FILE"
chmod 664 "$LOG_FILE"
chown root:docker "$LOG_FILE"

# systemd service dosyasını oluştur
echo "🛠️  systemd servisi oluşturuluyor: $SERVICE_FILE"
cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=Docker Container Watchdog - Auto Restart Exited Containers
After=docker.service
Requires=docker.service

[Service]
Type=simple
Restart=always
RestartSec=10
ExecStart=$SCRIPT_FILE

[Install]
WantedBy=multi-user.target
EOF

# systemd servisini aktif et
echo "🚀 Servis başlatılıyor..."
systemctl daemon-reload
systemctl enable docker-watchdog
systemctl start docker-watchdog

echo "✅ Kurulum tamamlandı! Servis aktif ve çalışıyor."