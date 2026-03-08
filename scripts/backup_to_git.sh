#!/bin/bash
# ============================================================
# Backup da memória dos agentes commitando no GitHub
# Necessário no Render (sem disco persistente)
# Agendar: rode via cron ou trigger externo
# ============================================================

set -e

DATE=$(date +"%Y-%m-%d %H:%M")

cd /app

# Configurar git
git config user.email "openclaw-bot@noreply.com"
git config user.name "OpenClaw Bot"

# Adicionar apenas o workspace (memória dos agentes)
git add workspace/

# Commitar se houver mudanças
if git diff --staged --quiet; then
  echo "Nenhuma mudança na memória para commitar."
else
  git commit -m "chore: memory snapshot $DATE"
  git push origin main
  echo "✅ Memória salva no GitHub!"
fi
