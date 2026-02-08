#!/bin/bash

# ============================================================================
# TeslaMate PostgreSQL Backup Script for Synology NAS
# ============================================================================

# Configuration
BACKUP_DIR="/volume1/docker/Teslamate/BackupTesla"
COMPOSE_DIR="/volume1/docker/teslamate"  # Pfad zu deinem docker-compose.yml
RETENTION_DAYS=30

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate filename with timestamp
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_FILE="$BACKUP_DIR/teslamate_$TIMESTAMP.dump"

# Navigate to docker-compose directory
cd "$COMPOSE_DIR" || exit 1

# Create backup
echo "Starting TeslaMate database backup..."
docker-compose exec -T database pg_dump -U teslamate -Fc teslamate > "$BACKUP_FILE"

# Check if backup was successful
if [ $? -eq 0 ] && [ -s "$BACKUP_FILE" ]; then
    echo "Backup successful: $BACKUP_FILE"
    echo "Size: $(du -h "$BACKUP_FILE" | cut -f1)"
else
    echo "ERROR: Backup failed!"
    rm -f "$BACKUP_FILE"
    exit 1
fi

# Delete backups older than retention period
echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "teslamate_*.dump" -mtime +$RETENTION_DAYS -delete

# List current backups
echo "Current backups:"
ls -lh "$BACKUP_DIR"

echo "Backup completed at $(date)"
