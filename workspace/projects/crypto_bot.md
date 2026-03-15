# Projeto: Crypto Bot — Arbitragem Solana

**Status**: Planejamento / Desenvolvimento inicial
**Responsável técnico**: DevBot
**Análise de mercado**: FinanceBot

---

## Objetivo
Bot de arbitragem automatizado entre DEXs Solana (Jupiter, Raydium, Orca).
Geração de renda passiva com capital inicial limitado.

## Stack Técnico
- Linguagem: Python 3.11+
- Libs: `solana-py`, `aiohttp`, `python-dotenv`
- RPC: mainnet-beta.solana.com (público) → migrar para RPC privado
- Execução: Oracle Cloud Free Tier (ARM)

## Estratégia Principal
- Arbitragem entre DEXs: compra no mais barato, vende no mais caro
- Pares: SOL/USDC, BONK/SOL, outros com volume alto
- Spread mínimo alvo: 1% (descontando taxas de rede)
- Varredura: a cada 60 segundos

## Gestão de Risco
- Máximo 10% do portfolio por trade
- Stop-loss: 8%
- Take-profit: 20%
- Monitoramento 24/7 de posições abertas

## Pré-requisitos para Produção
```bash
# 1. Dependências
pip install solana-py aiohttp python-dotenv

# 2. Variáveis de ambiente
export SOLANA_RPC_URL="https://api.mainnet-beta.solana.com"
export SOLANA_WALLET_PATH="/root/.openclaw/workspace/wallet.json"

# 3. Verificar saldo
solana balance
```

## Próximos Passos
- [ ] Configurar wallet real com saldo inicial
- [ ] Testar RPC latência (considerar Helius ou QuickNode free tier)
- [ ] Backtest de estratégia nos últimos 30 dias
- [ ] Deploy em produção no Oracle Cloud
- [ ] Alertas via Telegram quando oportunidade encontrada

## Alertas e Riscos
- RPC público pode ter latência alta em horários de pico
- Taxas de rede Solana podem consumir o spread em trades pequenos
- Arbitragem competitiva: outros bots fazem o mesmo
