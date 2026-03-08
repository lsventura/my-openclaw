#!/bin/bash
# ============================================================
# Backup da memória dos agentes
# Agendar no cron: 0 3 * * * bash ~/my-openclaw/scripts/backup.sh
# ============================================================

set -e
DATE=$(date +%Y%m%d_%H%M)
BACKUP_DIR=~/openclaw_backups
mkdir -p $BACKUP_DIR

echo "📦 Fazendo backup da memória..."
tar -czf "$BACKUP_DIR/workspace_$DATE.tar.gz" ~/my-openclaw/workspace/

# Manter apenas últimos 7 backups
cd $BACKUP_DIR
ls -t workspace_*.tar.gz | tail -n +8 | xargs -r rm

echo "✅ Backup salvo em $BACKUP_DIR/workspace_$DATE.tar.gz"
ls -lh $BACKUP_DIR | tail -5
