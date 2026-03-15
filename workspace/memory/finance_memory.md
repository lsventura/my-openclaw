# Memória Longa — FinanceBot

> Arquivo de memória persistente. Atualizado automaticamente no flush.
> Última atualização: 2026-03-14

## ESTRATÉGIAS ATIVAS
- **Arbitragem DEX Solana**: Jupiter ↔ Raydium ↔ Orca
  - Pares: SOL-USDC, BONK-SOL
  - Spread mínimo alvo: 1%
  - Estado: planejamento/código em desenvolvimento

## TRADES RECENTES
- Nenhum trade registrado ainda (bot em desenvolvimento)

## WATCHLIST
- SOL: base do bot de arbitragem
- BTC/USDT: referência de mercado
- ETH/USDT: referência DeFi
- BONK: par no bot Solana

## CONFIGURAÇÃO DO BOT
- Stack: Python + solana-py + aiohttp
- RPC: mainnet-beta.solana.com (público) → considerar RPC privado para produção
- Gestão de risco configurada: max 10% portfolio/trade, stop 8%, take 20%
- Status: aguardando wallet real e ambiente de execução configurado

## APRENDIZADOS DE MERCADO
- Arbitragem DEX: latência é crítica — RPC público pode ser lento demais
- Ambiente sandbox não tem rede → executar em host ou sandbox com bridge network
- Validar saldo e autoridades da wallet antes de qualquer execução real
