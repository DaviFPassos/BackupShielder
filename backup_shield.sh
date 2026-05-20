#!/bin/bash

BASE_DIR=$(pwd)
SOURCE_DIR="$BASE_DIR/source_apps"
BACKUP_VAULT="$BASE_DIR/backup_vault"
LOG_FILE="$BASE_DIR/logs/backup_history.log"

MAX_DISK_USAGE=80 # Alerta se o uso do disco do Linux passar de 80%
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_VAULT/backup_$TIMESTAMP.tar.gz"

echo "===================================================="
echo " BACKUP SHIELD KERNEL ACTIVE"
echo "====================================================" >> "$LOG_FILE"
echo "[$(date)] Starting system health and storage check..." | tee -a "$LOG_FILE"

# Captura o uso percentual da partição principal do WSL2
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

echo "[INFO] Current OS Disk Usage: $DISK_USAGE%" | tee -a "$LOG_FILE"

if [ -z "$(ls -A "$SOURCE_DIR")" ]; then
    echo "[WARNING] Source folder is empty. Nothing to archive." | tee -a "$LOG_FILE"
    exit 0
fi

echo "[SYSTEM] Initiating secure compression of source artifacts..." | tee -a "$LOG_FILE"

# O comando TAR junta todos os arquivos .txt e compacta em gzip na velocidade do Kernel
if tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" . ; then
    echo "[SUCCESS] Backup package successfully created at: $BACKUP_FILE" | tee -a "$LOG_FILE"
    
    FILE_HASH=$(md5sum "$BACKUP_FILE" | awk '{print $1}')
    echo "[SECURITY] MD5 Integrity Hash: $FILE_HASH" | tee -a "$LOG_FILE"
    
    echo "[CLEANUP] Purging volatile logs from source directory..." | tee -a "$LOG_FILE"
    rm -f "$SOURCE_DIR"/*.txt
    
    python3 "$BASE_DIR/helper_formatter.py" "$FILENAME" "$DISK_USAGE" "$FILE_HASH"
    
else
    echo "[CRITICAL ERROR] Backup compression failed. Aborting cleanup." | tee -a "$LOG_FILE"
    exit 1
fi

echo "====================================================" | tee -a "$LOG_FILE"