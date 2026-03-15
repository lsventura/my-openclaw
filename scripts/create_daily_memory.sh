#!/bin/bash
# Cria os arquivos de memória diária para todos os agentes
# Rodar uma vez por dia: crontab -e -> 0 3 * * * /root/my-openclaw/scripts/create_daily_memory.sh

DATE=$(date +%Y-%m-%d)
WORKSPACE="$HOME/.openclaw/workspace/memory"
AGENTS=("boss" "dev" "finance" "research" "life")

mkdir -p "$WORKSPACE/daily"
for AGENT in "${AGENTS[@]}"; do
  mkdir -p "$WORKSPACE/agents/$AGENT"
done

# Criar daily log do dia
DAILY_FILE="$WORKSPACE/daily/$DATE.md"
if [ ! -f "$DAILY_FILE" ]; then
  cat > "$DAILY_FILE" << EOF
# Diário — $DATE

## Resumo do dia
_(preenchido pelos agentes ao longo do dia)_

## Tarefas concluídas
-

## Decisões tomadas
-

## Oportunidades identificadas
-

## Pendente para amanhã
-
EOF
  echo "[OK] Criado: $DAILY_FILE"
fi

# Criar memória diária por agente
for AGENT in "${AGENTS[@]}"; do
  AGENT_FILE="$WORKSPACE/agents/$AGENT/$DATE.md"
  if [ ! -f "$AGENT_FILE" ]; then
    AGENT_UPPER=$(echo "$AGENT" | tr '[:lower:]' '[:upper:]')
    cat > "$AGENT_FILE" << EOF
# $AGENT_UPPER — $DATE

## Tarefas do dia
- [ ]

## Decisões tomadas
-

## Oportunidades identificadas
-

## Pendente para amanhã
-
EOF
    echo "[OK] Criado: $AGENT_FILE"
  else
    echo "[--] Já existe: $AGENT_FILE"
  fi
done

echo "✅ Memória diária pronta para $DATE"
