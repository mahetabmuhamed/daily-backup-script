#!/bin/bash

# === Configuration ===
SOURCE="/etc"                          # Folder to back up
DEST="/home/mahy/backups"              # Where to save backups
LOGS="/home/mahy/logs"                 # Where to save logs
KEEP_BACKUPS=7                         # Keep last 7 backups
KEEP_LOGS=5                            # Keep last 5 logs

# === Date Format ===
DATE=$(date +%Y-%m-%d-%H%M)            # Example: 2025-04-10-1400
FILE="backup-$DATE.tar.gz"            # Example: backup-2025-04-10-1400.tar.gz
LOGFILE="$LOGS/backup-$DATE.log"      # Log file path
EMAIL="root"                           # Send alerts to root

# === Make folders if they don't exist ===
mkdir -p "$DEST"
mkdir -p "$LOGS"

# === Start backup ===
echo "Backup started at $DATE" >> "$LOGFILE"
tar -czf "$DEST/$FILE" "$SOURCE" >> "$LOGFILE" 2>&1

# === Check success ===
if [ $? -eq 0 ]; then
  echo "Backup successful" >> "$LOGFILE"
else
  echo "Backup failed" >> "$LOGFILE"
  echo "Backup failed at $DATE" | mail -s "Backup Failed!" root
fi

# === Delete backups older than 7 days ===
find "$DEST" -name "*.tar.gz" -mtime +$KEEP_BACKUPS -exec rm -f {} \;

# === Delete logs older than 5 days ===
find "$LOGS" -name "*.log" -mtime +$KEEP_LOGS -exec rm -f {} \;
