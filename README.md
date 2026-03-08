# 🤖 My OpenClaw Agent System

Sistema multi-agente pessoal baseado em [OpenClaw](https://openclaw.ai), hospedado no Oracle Cloud Free Tier com LLMs gratuitos via OpenRouter.

## Stack
- **Runtime**: OpenClaw (Node.js)
- **LLM**: OpenRouter (Kimi K2 free / Gemini Flash free)
- **Interface**: Telegram Bot
- **Hosting**: Oracle Cloud Free Tier (ARM VM)
- **Memória**: File-based (JSON + Markdown)

## Arquitetura de Agentes

```
Você (Telegram)
     ↓
[ Boss Agent - Amora ]  ← Orquestrador central
     ├── [ Finance Agent ]  ← Cripto, análises, watchlists
     ├── [ Dev Agent ]      ← Código, debug, automações
     ├── [ Research Agent ] ← Pesquisa web, notícias
     └── [ Life Agent ]     ← Agenda, lembretes, tarefas
```

## Setup Rápido

Veja [docs/SETUP.md](docs/SETUP.md) para guia completo de instalação.

## Estrutura

```
my-openclaw/
├── agents/              # Definições dos agentes (YAML)
│   ├── boss.yaml
│   ├── finance.yaml
│   ├── dev.yaml
│   ├── research.yaml
│   └── life.yaml
├── workspace/           # Memória compartilhada entre agentes
│   ├── decisions/       # Decisões importantes tomadas
│   ├── projects/        # Estado dos projetos ativos
│   ├── context/         # Contexto pessoal (quem você é)
│   └── tools/           # Scripts customizados
├── scripts/             # Setup e manutenção do servidor
│   ├── install.sh
│   ├── update.sh
│   └── backup.sh
├── config/
│   └── openclaw.json    # Configuração principal
└── docs/
    ├── SETUP.md
    └── AGENTS.md
```
