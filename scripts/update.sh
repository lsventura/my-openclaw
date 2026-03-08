#!/bin/bash
# ============================================================
# Atualiza o sistema OpenClaw (repo + dependências)
# ============================================================

set -e
cd ~/my-openclaw

echo "🔄 Atualizando repositório..."
git pull origin main

echo "📦 Atualizando OpenClaw..."
sudo npm update -g openclaw

echo "🔁 Reiniciando daemon..."
openclaw daemon restart

echo "✅ Atualização concluída!"
openclaw status
