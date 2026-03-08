#!/bin/bash
# ============================================================
# Script de instalação do OpenClaw no Oracle Cloud (ARM/Ubuntu)
# Uso: bash scripts/install.sh
# ============================================================

set -e

echo "🚀 Iniciando instalação do OpenClaw..."

# --- 1. Atualizar sistema ---
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl git unzip

# --- 2. Instalar Node.js 22 ---
echo "📦 Instalando Node.js 22..."
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
echo "Node.js: $(node -v) | npm: $(npm -v)"

# --- 3. Instalar OpenClaw globalmente ---
echo "🦀 Instalando OpenClaw..."
sudo npm install -g openclaw
echo "OpenClaw: $(openclaw --version)"

# --- 4. Criar diretório de logs ---
sudo mkdir -p /var/log/openclaw
sudo chown $USER:$USER /var/log/openclaw

# --- 5. Clonar este repositório ---
cd ~
if [ ! -d "my-openclaw" ]; then
  echo "📁 Clonando repositório..."
  git clone https://github.com/lsventura/my-openclaw.git
  cd my-openclaw
else
  echo "📁 Repositório já existe, atualizando..."
  cd my-openclaw
  git pull
fi

# --- 6. Criar .env a partir do template ---
if [ ! -f ".env" ]; then
  cp .env.example .env
  echo "\n⚠️  IMPORTANTE: Edite o arquivo .env com suas chaves:"
  echo "   nano ~/.my-openclaw/.env"
fi

# --- 7. Iniciar daemon OpenClaw ---
echo "🤖 Configurando daemon..."
openclaw onboard --config config/openclaw.json --install-daemon

echo ""
echo "✅ Instalação concluída!"
echo "📱 Abra o Telegram e fale com seu bot."
echo "📋 Logs em: /var/log/openclaw/openclaw.log"
echo "🔑 Lembre de preencher o .env!"
