#!/bin/bash
# Setup completo do OpenClaw — rodar uma vez após git pull
set -e

echo "🦞 Iniciando setup do OpenClaw..."

# 1. Copiar config base
cp config/openclaw.json ~/.openclaw/openclaw.json
chmod 600 ~/.openclaw/openclaw.json
echo "[OK] config copiado"

# 2. Registrar OpenRouter como provider via openclaw configure
echo ""
echo "==> Configurando OpenRouter como provider de modelos..."
openclaw configure --provider openrouter --api-key "$OPENROUTER_API_KEY" 2>/dev/null || \
openclaw config set models.providers.openrouter.apiKey "$OPENROUTER_API_KEY"
echo "[OK] OpenRouter configurado"

# 3. Copiar agentes para o diretório do openclaw
echo ""
echo "==> Copiando agentes..."
mkdir -p ~/.openclaw/agents
for f in agents/*.yaml; do
  agent_id=$(grep '^id:' "$f" | awk '{print $2}')
  mkdir -p ~/.openclaw/agents/$agent_id
  cp "$f" ~/.openclaw/agents/$agent_id/agent.yaml 2>/dev/null || \
  cp "$f" ~/.openclaw/agents/$agent_id/config.yaml 2>/dev/null || \
  cp "$f" ~/.openclaw/agents/$agent_id/
  echo "[OK] $agent_id"
done

# 4. Criar estrutura de memória
bash scripts/create_daily_memory.sh

# 5. Otimizações de performance
export NODE_COMPILE_CACHE=/var/tmp/openclaw-compile-cache
export OPENCLAW_NO_RESPAWN=1
mkdir -p /var/tmp/openclaw-compile-cache

# Persistir no bashrc se ainda não tiver
grep -q 'NODE_COMPILE_CACHE' ~/.bashrc || cat >> ~/.bashrc << 'EOF'
export NODE_COMPILE_CACHE=/var/tmp/openclaw-compile-cache
export OPENCLAW_NO_RESPAWN=1
EOF

# 6. Reiniciar gateway
screen -S friday -X quit 2>/dev/null || true
sleep 1
screen -dmS friday openclaw gateway
sleep 3

# 7. Status final
echo ""
openclaw models list
echo ""
openclaw status
echo ""
echo "✅ Setup concluído! Friday está rodando."
