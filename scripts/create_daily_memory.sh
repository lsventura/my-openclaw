#!/bin/bash
# Cria arquivos de memória diária para todos os agentes
# Agendar: crontab -e -> 0 3 * * * ~/my-openclaw/my-openclaw/scripts/create_daily_memory.sh

DATE=$(date +%Y-%m-%d)
WORKSPACE="$HOME/.openclaw/workspace/memory"
AGENTS=("boss" "dev" "finance" "research" "life")

mkdir -p "$WORKSPACE/daily"
for AGENT in "${AGENTS[@]}"; do
  mkdir -p "$WORKSPACE/agents/$AGENT"
done

# Criar daily log
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
  echo "[OK] $DAILY_FILE"
fi

# Criar memória por agente
for AGENT in "${AGENTS[@]}"; do
  AGENT_FILE="$WORKSPACE/agents/$AGENT/$DATE.md"
  if [ ! -f "$AGENT_FILE" ]; then
    LABEL=$(echo "$AGENT" | tr '[:lower:]' '[:upper:]')
    cat > "$AGENT_FILE" << EOF
# $LABEL — $DATE

## Tarefas do dia
- [ ]

## Decisões tomadas
-

## Oportunidades identificadas
-

## Pendente para amanhã
-
EOF
    echo "[OK] $AGENT_FILE"
  else
    echo "[--] Já existe: $AGENT_FILE"
  fi
done

echo "✅ Memória diária pronta para $DATE"
