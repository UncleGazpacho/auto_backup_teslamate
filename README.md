# TeslaMate PostgreSQL Backup Script

Automated backup script for the TeslaMate PostgreSQL database running in Docker on a Synology NAS.

## Features

- Compressed backups using `pg_dump -Fc` (Custom Format) via `docker-compose`
- Automatic cleanup of backups older than the retention period

## Configuration

Edit the variables at the top of `teslamate_backup.sh`:

| Variable | Default | Description |
|---|---|---|
| `BACKUP_DIR` | `/volume1/docker/Teslamate/BackupTesla` | Where backups are stored |
| `COMPOSE_DIR` | `/volume1/docker/Teslamate` | Path to your `docker-compose.yml` |
| `RETENTION_DAYS` | `30` | Days to keep old backups |

## Usage

### Manual run

```bash
./teslamate_backup.sh
```

### Scheduled via Synology Task Scheduler

1. Open **Control Panel > Task Scheduler**
2. Click **Create > Scheduled Task > User-defined script**
3. Set the schedule (e.g. daily at 3:00 AM)
4. Under **Task Settings**, paste the script path:
   ```
   /path/to/teslamate_backup.sh
   ```
5. Run the task as **root** (required for Docker access)

### Restore from backup

```bash
cd /volume1/docker/Teslamate
docker-compose exec -T database pg_restore -U teslamate -d teslamate --clean < /volume1/docker/Teslamate/BackupTesla/teslamate_2025-01-01.dump
```

> **Hinweis:** Das Custom Format (`-Fc`) erfordert `pg_restore` statt `psql`. Die Option `--clean` löscht bestehende Objekte vor dem Restore.
