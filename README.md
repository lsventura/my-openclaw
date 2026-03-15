# 🦞 OpenClaw — Friday AI System

Sistema multi-agente de IA para crypto futures trading, rodando 24/7 em VPS com interface via Telegram.

## Arquitetura

```
Friday (main)        → boss, interface com Leonardo via Telegram
├── researcher       → analisa mercado, define estratégias de scalping
├── dev              → implementa e mantém o bot de trading em Python
└── trader           → monitora operações, reporta PnL e alertas
```

## Stack

- **OpenClaw 2026.3.13** — framework multi-agente
- **OpenRouter** — acesso a LLMs (DeepSeek R1, DeepSeek V3, Gemini Flash, auto)
- **Telegram Bot** — interface de comunicação
- **Binance Futures API** — execução de ordens
- **DigitalOcean VPS** — Ubuntu 22.04, 1vCPU 1GB RAM
- **systemd** — supervisor do gateway

## Modelos por agente

| Agente | Modelo | Função |
|---|---|---|
| friday (main) | openrouter/auto | Boss, coordenação geral |
| researcher | deepseek/deepseek-r1-0528 | Análise estatística, estratégias |
| dev | deepseek/deepseek-v3.2 | Implementação de código |
| trader | google/gemini-2.5-flash | Monitoramento rápido, alertas |

## Skills instaladas

- `web` — busca na web
- `summarize` — resume URLs e arquivos
- `session-logs` — analisa histórico de conversas
- `github` — gerencia repositório
- `tmux` — controla processos em background
- `weather` — previsão do tempo
- `healthcheck` — auditoria de segurança do servidor

## Cron Jobs

| Job | Agente | Frequência | Função |
|---|---|---|---|
| researcher-market-analysis | researcher | 30min | Analisa mercado, define estratégia |
| dev-implement-strategy | dev | 1h | Implementa estratégias do researcher |
| trader-monitor | trader | 15min | Monitora bot, reporta PnL |

---

## Instalação do zero

Ver `setup.sh` para instalação automatizada completa.

### Pré-requisitos

- VPS Ubuntu 22.04+ com acesso root
- Chaves de API: OpenRouter, Telegram Bot, Binance Futures

### Quick start

```bash
git clone https://github.com/lsventura/my-openclaw.git
cd my-openclaw
cp .env.example .env
# edite o .env com suas chaves
bash setup.sh
```

---

## Backup e restore

Arquivos críticos salvos neste repo:

```
config/openclaw.json          → config principal do gateway
config/identity-friday.md     → personalidade da Friday (main)
config/identity-researcher.md → personalidade do researcher
config/identity-dev.md        → personalidade do dev
config/identity-trader.md     → personalidade do trader
```

Para restaurar em nova máquina:
```bash
bash setup.sh
```
