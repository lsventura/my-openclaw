#!/bin/bash
# ============================================================
# Setup completo do OpenClaw no DigitalOcean (1 GB RAM)
# Uso: bash scripts/setup-digitalocean.sh
# ============================================================

set -e

BOLD=$(tput bold)
RESET=$(tput sgr0)
GREEN='\e[32m'
YELLOW='\e[33m'
RED='\e[31m'
NC='\e[0m'

echo -e "${GREEN}${BOLD}"
echo "  =========================================="
echo "   🦞 OpenClaw — Setup DigitalOcean 1GB"
echo "  =========================================="
echo -e "${RESET}"

# --- 1. Otimizações de ambiente para VM pequena ---
echo -e "${YELLOW}[1/7] Configurando variáveis de ambiente...${NC}"
export NODE_COMPILE_CACHE=/var/tmp/openclaw-compile-cache
mkdir -p /var/tmp/openclaw-compile-cache
export OPENCLAW_NO_RESPAWN=1
export NODE_OPTIONS="--max-old-space-size=640"

# Tornar permanente
grep -qxF 'export NODE_COMPILE_CACHE=/var/tmp/openclaw-compile-cache' ~/.bashrc || echo 'export NODE_COMPILE_CACHE=/var/tmp/openclaw-compile-cache' >> ~/.bashrc
grep -qxF 'export OPENCLAW_NO_RESPAWN=1' ~/.bashrc || echo 'export OPENCLAW_NO_RESPAWN=1' >> ~/.bashrc
grep -qxF 'export NODE_OPTIONS="--max-old-space-size=640"' ~/.bashrc || echo 'export NODE_OPTIONS="--max-old-space-size=640"' >> ~/.bashrc
echo -e "  ${GREEN}✓ Variáveis configuradas${NC}"

# --- 2. SWAP de 2GB (resolve OOM no 1GB RAM) ---
echo -e "${YELLOW}[2/7] Criando SWAP de 2GB...${NC}"
if swapon --show | grep -q /swapfile; then
  echo -e "  ${GREEN}✓ SWAP já existe, pulando${NC}"
else
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  grep -qxF '/swapfile none swap sw 0 0' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
  echo -e "  ${GREEN}✓ SWAP 2GB ativado${NC}"
fi

# --- 3. Instalar Node.js 22 ---
echo -e "${YELLOW}[3/7] Instalando Node.js 22...${NC}"
if node -v 2>/dev/null | grep -q 'v22'; then
  echo -e "  ${GREEN}✓ Node.js 22 já instalado: $(node -v)${NC}"
else
  apt-get update -qq
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash - > /dev/null 2>&1
  apt-get install -y nodejs > /dev/null 2>&1
  echo -e "  ${GREEN}✓ Node.js instalado: $(node -v)${NC}"
fi

# --- 4. Instalar OpenClaw ---
echo -e "${YELLOW}[4/7] Instalando OpenClaw...${NC}"
if command -v openclaw &> /dev/null; then
  echo -e "  ${GREEN}✓ OpenClaw já instalado: $(openclaw --version 2>/dev/null || echo 'ok')${NC}"
else
  npm install -g openclaw 2>/dev/null
  echo -e "  ${GREEN}✓ OpenClaw instalado${NC}"
fi

# --- 5. Criar diretório de logs ---
echo -e "${YELLOW}[5/7] Criando diretórios...${NC}"
mkdir -p /var/log/openclaw
mkdir -p ~/.openclaw
echo -e "  ${GREEN}✓ Diretórios criados${NC}"

# --- 6. Configurar .env ---
echo -e "${YELLOW}[6/7] Configurando credenciais...${NC}"

if [ -f ".env" ] && grep -q 'TELEGRAM_BOT_TOKEN=seu_token' .env; then
  echo -e "  ${YELLOW}⚠ Arquivo .env existe mas ainda tem valores padrão.${NC}"
  CONFIGURE_ENV=true
elif [ ! -f ".env" ]; then
  cp .env.example .env
  CONFIGURE_ENV=true
else
  echo -e "  ${GREEN}✓ .env já configurado${NC}"
  CONFIGURE_ENV=false
fi

if [ "$CONFIGURE_ENV" = true ]; then
  echo ""
  echo -e "${BOLD}Vamos configurar suas credenciais agora:${RESET}"
  echo ""

  # Telegram Bot Token
  echo -e "${YELLOW}📱 TELEGRAM BOT TOKEN${NC}"
  echo "   → Obter em: https://t.me/BotFather → /newbot"
  read -p "   Cole o token aqui: " TELEGRAM_TOKEN

  # Telegram User ID
  echo ""
  echo -e "${YELLOW}🔢 SEU TELEGRAM USER ID (número)${NC}"
  echo "   → Obter em: https://t.me/userinfobot"
  read -p "   Cole seu ID aqui: " TELEGRAM_ID

  # OpenRouter ou Gemini
  echo ""
  echo -e "${YELLOW}🤖 QUAL LLM VOCÊ VAI USAR?${NC}"
  echo "   1) OpenRouter (grátis — openrouter.ai)"
  echo "   2) Google Gemini (grátis — aistudio.google.com)"
  read -p "   Escolha [1/2]: " LLM_CHOICE

  if [ "$LLM_CHOICE" = "2" ]; then
    echo ""
    echo -e "${YELLOW}🔑 GOOGLE GEMINI API KEY${NC}"
    echo "   → Obter em: https://aistudio.google.com → Get API Key"
    read -p "   Cole a chave AIza... aqui: " GEMINI_KEY

    cat > .env << EOF
TELEGRAM_BOT_TOKEN=${TELEGRAM_TOKEN}
TELEGRAM_USER_ID=${TELEGRAM_ID}
GOOGLE_AI_API_KEY=${GEMINI_KEY}
NODE_COMPILE_CACHE=/var/tmp/openclaw-compile-cache
OPENCLAW_NO_RESPAWN=1
NODE_OPTIONS=--max-old-space-size=640
EOF

    # Atualizar config para usar Gemini
    sed -i 's/"provider": "openrouter"/"provider": "google"/g' config/openclaw.json
    sed -i 's/"moonshotai\/kimi-k2"/"gemini-2.0-flash"/g' config/openclaw.json
    sed -i 's/"OPENROUTER_API_KEY"/"GOOGLE_AI_API_KEY"/g' config/openclaw.json
    sed -i 's|"https://openrouter.ai/api/v1"|"https://generativelanguage.googleapis.com/v1beta/openai/"|g' config/openclaw.json

  else
    echo ""
    echo -e "${YELLOW}🔑 OPENROUTER API KEY${NC}"
    echo "   → Obter em: https://openrouter.ai → Keys → Create Key"
    read -p "   Cole a chave sk-or-v1-... aqui: " OR_KEY

    cat > .env << EOF
TELEGRAM_BOT_TOKEN=${TELEGRAM_TOKEN}
TELEGRAM_USER_ID=${TELEGRAM_ID}
OPENROUTER_API_KEY=${OR_KEY}
NODE_COMPILE_CACHE=/var/tmp/openclaw-compile-cache
OPENCLAW_NO_RESPAWN=1
NODE_OPTIONS=--max-old-space-size=640
EOF
  fi

  echo -e "  ${GREEN}✓ .env configurado${NC}"
fi

# Exportar variáveis do .env para a sessão atual
export $(grep -v '^#' .env | xargs)

# --- 7. Iniciar OpenClaw ---
echo ""
echo -e "${YELLOW}[7/7] Iniciando OpenClaw...${NC}"
echo ""
echo -e "${GREEN}${BOLD}✅ Setup concluído! Iniciando o sistema...${RESET}"
echo ""
echo -e "  💡 Dica: após subir, fale com seu bot no Telegram:"
echo -e "     'Oi Amora, estou online!'"
echo ""
echo -e "  💡 Para rodar em background use:"
echo -e "     openclaw daemon start"
echo ""
echo "─────────────────────────────────────────"

# Iniciar gateway
openclaw gateway start
