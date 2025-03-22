# immortal_docker
Allows your docker containers to be restarted as systemd without relying on docker


sudo dpkg -i docker-watchdog.deb
sudo systemctl daemon-reload
sudo systemctl enable docker-watchdog
sudo systemctl start docker-watchdog


