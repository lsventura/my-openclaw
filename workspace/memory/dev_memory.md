# Memória Longa — DevBot

> Arquivo de memória persistente. Atualizado automaticamente no flush.
> Última atualização: 2026-03-14

## PROJETOS EM DESENVOLVIMENTO
- **OpenClaw Multi-Agent**: configurado com 5 agentes (boss, dev, finance, research, life)
  - Stack: OpenClaw + OpenRouter (modelos gratuitos) + Oracle Cloud
  - Estado: configuração corrigida, aguardando validação em produção
- **Crypto Bot Solana**: planejamento de bot de arbitragem entre DEXs
  - Stack: Python, solana-py, aiohttp
  - Estado: planejamento; precisa de wallet real e RPC configurados

## PADRÕES ESTABELECIDOS
- Variáveis sensíveis sempre via os.getenv() + .env
- Logs estruturados em projetos de produção
- Free-tier primeiro (Oracle, Railway, OpenRouter, modelos gratuitos)
- Python como linguagem principal

## BUGS CONHECIDOS
- Sandbox OpenClaw: `workspaceAccess: none` impede acesso ao workspace real → fix: `rw`
- Canal Telegram silencioso após sobrescrever openclaw.json → fix: preservar `channels.telegram`

## DECISÕES TÉCNICAS
- Escolha do moonshotai/kimi-k2 como modelo padrão: melhor custo-benefício gratuito para coding
- Gemini 2.5 Pro free para tarefas financeiras: raciocínio mais profundo
- Llama 3.3 70B free para life agent: leve e suficiente para tarefas simples
