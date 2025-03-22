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
