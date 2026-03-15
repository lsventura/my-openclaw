#!/usr/bin/env bash
set -e

echo "🦞 OpenClaw Setup — Friday AI System"
echo "======================================"

# ── 1. Variáveis de ambiente ──────────────────────────────────────────────────
if [ ! -f .env ]; then
  echo "❌ Arquivo .env não encontrado. Copie .env.example e preencha as chaves."
  exit 1
fi

set -a; source .env; set +a

REQUIRED_VARS=(OPENROUTER_API_KEY TELEGRAM_BOT_TOKEN TELEGRAM_USER_ID BINANCE_API_KEY BINANCE_API_SECRET)
for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var}" ]; then
    echo "❌ Variável $var não definida no .env"
    exit 1
  fi
done

echo "✅ Variáveis de ambiente OK"

# ── 2. Dependências do sistema ────────────────────────────────────────────────
echo "📦 Instalando dependências..."
apt-get update -qq
apt-get install -y -qq jq ripgrep curl git

# ── 3. Node.js ────────────────────────────────────────────────────────────────
if ! command -v node &> /dev/null; then
  echo "📦 Instalando Node.js 22..."
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
  apt-get install -y nodejs
fi
echo "✅ Node.js $(node --version)"

# ── 4. OpenClaw ───────────────────────────────────────────────────────────────
if ! command -v openclaw &> /dev/null; then
  echo "📦 Instalando OpenClaw..."
  npm install -g openclaw
fi
echo "✅ OpenClaw $(openclaw --version 2>/dev/null || echo 'instalado')"

# ── 5. Config principal ───────────────────────────────────────────────────────
echo "⚙️  Configurando openclaw.json..."
mkdir -p ~/.openclaw

# Gera token do gateway se não existir
GATEWAY_TOKEN=${OPENCLAW_GATEWAY_TOKEN:-$(openssl rand -hex 24)}

cat > ~/.openclaw/openclaw.json << EOF
{
  "\$schema": "https://openclaw.ai/schema/config.json",
  "meta": {
    "lastTouchedVersion": "2026.3.13",
    "lastTouchedAt": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"
  },
  "env": {
    "OPENROUTER_API_KEY": "\${OPENROUTER_API_KEY}",
    "TELEGRAM_BOT_TOKEN": "\${TELEGRAM_BOT_TOKEN}",
    "TELEGRAM_USER_ID": "\${TELEGRAM_USER_ID}",
    "BINANCE_API_KEY": "\${BINANCE_API_KEY}",
    "BINANCE_API_SECRET": "\${BINANCE_API_SECRET}"
  },
  "wizard": {
    "lastRunAt": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)",
    "lastRunVersion": "2026.3.13",
    "lastRunCommand": "configure",
    "lastRunMode": "local"
  },
  "auth": {
    "profiles": {
      "openrouter:default": {
        "provider": "openrouter",
        "mode": "api_key"
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "openrouter/auto"
      },
      "models": {
        "openrouter/deepseek/deepseek-v3.2": {},
        "openrouter/deepseek/deepseek-r1-0528": {},
        "openrouter/google/gemini-2.5-flash": {},
        "openrouter/google/gemini-2.5-pro": {},
        "openrouter/meta-llama/llama-3.3-70b-instruct:free": {}
      },
      "workspace": "~/.openclaw/workspace",
      "memorySearch": { "enabled": false },
      "compaction": { "mode": "safeguard" },
      "sandbox": { "mode": "off" }
    }
  },
  "tools": {
    "profile": "full",
    "elevated": {
      "enabled": true,
      "allowFrom": {
        "telegram": ["\${TELEGRAM_USER_ID}"]
      }
    }
  },
  "commands": {
    "native": "auto",
    "nativeSkills": "auto",
    "restart": true,
    "ownerDisplay": "raw"
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "open",
      "botToken": "\${TELEGRAM_BOT_TOKEN}",
      "allowFrom": ["*"],
      "groupPolicy": "open",
      "streaming": "partial"
    }
  },
  "gateway": {
    "port": 3000,
    "mode": "local",
    "bind": "lan",
    "controlUi": {
      "allowedOrigins": ["http://localhost:3000", "http://127.0.0.1:3000"]
    },
    "auth": {
      "mode": "token",
      "token": "$GATEWAY_TOKEN"
    }
  }
}
EOF

echo "✅ openclaw.json configurado"

# ── 6. Auth OpenRouter ────────────────────────────────────────────────────────
echo "🔑 Configurando auth OpenRouter..."
mkdir -p ~/.openclaw/agents/main/agent
cat > ~/.openclaw/agents/main/agent/auth-profiles.json << EOF
{
  "openrouter:default": {
    "provider": "openrouter",
    "mode": "api_key",
    "apiKey": "$OPENROUTER_API_KEY"
  }
}
EOF
echo "✅ Auth OpenRouter configurado"

# ── 7. Identidades dos agentes ────────────────────────────────────────────────
echo "🤖 Configurando identidades dos agentes..."

# Friday (main)
cp config/identity-friday.md ~/.openclaw/agents/main/agent/IDENTITY.md

# Researcher
mkdir -p ~/.openclaw/agents/researcher/agent
cp config/identity-researcher.md ~/.openclaw/agents/researcher/agent/IDENTITY.md
cat > ~/.openclaw/agents/researcher/agent/auth-profiles.json << EOF
{
  "openrouter:default": {
    "provider": "openrouter",
    "mode": "api_key",
    "apiKey": "$OPENROUTER_API_KEY"
  }
}
EOF

# Dev
mkdir -p ~/.openclaw/agents/dev/agent
cp config/identity-dev.md ~/.openclaw/agents/dev/agent/IDENTITY.md
cat > ~/.openclaw/agents/dev/agent/auth-profiles.json << EOF
{
  "openrouter:default": {
    "provider": "openrouter",
    "mode": "api_key",
    "apiKey": "$OPENROUTER_API_KEY"
  }
}
EOF

# Trader
mkdir -p ~/.openclaw/agents/trader/agent
cp config/identity-trader.md ~/.openclaw/agents/trader/agent/IDENTITY.md
cat > ~/.openclaw/agents/trader/agent/auth-profiles.json << EOF
{
  "openrouter:default": {
    "provider": "openrouter",
    "mode": "api_key",
    "apiKey": "$OPENROUTER_API_KEY"
  }
}
EOF

echo "✅ Identidades configuradas"

# ── 8. Skills ─────────────────────────────────────────────────────────────────
echo "🛠️  Instalando skills..."
npx clawhub install github --force 2>/dev/null || true
npx clawhub install tmux --force 2>/dev/null || true
npx clawhub install summarize --force 2>/dev/null || true
npx clawhub install session-logs --force 2>/dev/null || true
npx clawhub install web --force 2>/dev/null || true
echo "✅ Skills instaladas"

# ── 9. systemd service ────────────────────────────────────────────────────────
echo "⚙️  Configurando systemd..."
OPENCLAW_BIN=$(which openclaw)

cat > /etc/systemd/system/openclaw.service << EOF
[Unit]
Description=OpenClaw Gateway
After=network.target

[Service]
Type=simple
User=root
EnvironmentFile=$(pwd)/.env
ExecStart=$OPENCLAW_BIN gateway
Restart=always
RestartSec=5
Environment=HOME=/root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable openclaw
systemctl restart openclaw
sleep 3

if systemctl is-active --quiet openclaw; then
  echo "✅ Gateway rodando via systemd"
else
  echo "❌ Gateway falhou ao iniciar. Verifique: journalctl -u openclaw -n 20"
  exit 1
fi

# ── 10. Cron jobs ─────────────────────────────────────────────────────────────
echo "⏰ Configurando cron jobs..."
TOKEN=$GATEWAY_TOKEN
TO=$TELEGRAM_USER_ID
URL="ws://127.0.0.1:3000"

# Registra agentes
openclaw agents add researcher --model openrouter/deepseek/deepseek-r1-0528 --workspace ~/.openclaw/workspace --non-interactive 2>/dev/null || true
openclaw agents add dev --model openrouter/deepseek/deepseek-v3.2 --workspace ~/.openclaw/workspace --non-interactive 2>/dev/null || true
openclaw agents add trader --model openrouter/google/gemini-2.5-flash --workspace ~/.openclaw/workspace --non-interactive 2>/dev/null || true

sleep 2

openclaw cron add \
  --name "researcher-market-analysis" \
  --agent researcher \
  --every 30m \
  --message "Analise o mercado de crypto futures agora. Pesquise as melhores oportunidades de scalping em BTC, ETH e SOL. Identifique a melhor estratégia atual com entry/exit rules, stop loss e take profit. Passe o resultado completo para o agente dev implementar." \
  --announce \
  --to $TO \
  --timeout-seconds 120 \
  --tz "America/Sao_Paulo" \
  --url $URL \
  --token $TOKEN 2>/dev/null || echo "⚠️  Cron researcher já existe ou falhou"

openclaw cron add \
  --name "dev-implement-strategy" \
  --agent dev \
  --every 1h \
  --message "Verifique se o researcher passou alguma estratégia nova. Se sim, implemente o bot Python para Binance Futures com a estratégia recebida. Use testnet primeiro. Commit no GitHub após implementar." \
  --announce \
  --to $TO \
  --timeout-seconds 180 \
  --tz "America/Sao_Paulo" \
  --url $URL \
  --token $TOKEN 2>/dev/null || echo "⚠️  Cron dev já existe ou falhou"

openclaw cron add \
  --name "trader-monitor" \
  --agent trader \
  --every 15m \
  --message "Verifique o status do bot de trading. Reporte para Leonardo: posições abertas, PnL atual, últimos sinais disparados. Se houver erro ou drawdown anormal, alerte imediatamente." \
  --announce \
  --to $TO \
  --timeout-seconds 60 \
  --tz "America/Sao_Paulo" \
  --url $URL \
  --token $TOKEN 2>/dev/null || echo "⚠️  Cron trader já existe ou falhou"

echo ""
echo "🎉 Setup completo!"
echo "=================="
echo "Gateway:   http://$(curl -s ifconfig.me):3000"
echo "Telegram:  @ArbitSanches_bot"
echo "Agentes:   friday, researcher, dev, trader"
echo ""
openclaw agents list
openclaw cron list --url $URL --token $TOKEN
