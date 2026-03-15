# Decisões Recentes

> Registro cronológico de decisões importantes.

---

## 2026-03-14 — Correção completa da configuração OpenClaw

**Problema**: Bot Telegram parou de responder após reconfiguração do sandbox.

**Causa raiz**: O comando de configuração do sandbox sobrescreveu todo o `openclaw.json`,
apagando a seção `channels.telegram`. Além disso, a chave estava errada
(`telegram.token` em vez de `channels.telegram.botToken`).

**Solução aplicada**:
- Corrigida estrutura do canal: `channels.telegram.botToken`
- Adicionado `dmPolicy: pairing` e `groups.requireMention: false`
- Sandbox mantido com `workspaceAccess: rw` e `docker.network: bridge`
- Envs explicitamente declaradas no sandbox (`docker.env`)
- Todos os 5 agentes formalizados na lista de `agents.list`
- Memória longa criada para cada agente

**Modelo Gemini 2.5 Pro** adicionado aos free_models (lançado em março 2026).

---

## 2026-03-08 — Setup inicial do OpenClaw

**Decisão**: Usar OpenClaw como sistema central de agentes IA pessoais.

**Motivação**: Interface Telegram + multi-agente + free-tier OpenRouter + auto-hospedagem
no Oracle Cloud Free Tier = custo zero com capacidade profissional.

**Stack escolhido**:
- OpenClaw (gateway + agents)
- OpenRouter (modelos gratuitos: kimi-k2, gemini, llama, deepseek)
- Oracle Cloud ARM (4 vCPU, 24GB RAM free)
- Telegram como interface
