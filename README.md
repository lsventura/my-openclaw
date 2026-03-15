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
- **DigitalOcean VPS** — Ubuntu 22.04, 4GB RAM (SFO3)
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

## Cron Jobs ativos

| Job | Agente | Frequência | Função |
|---|---|---|---|
| researcher-market-analysis | researcher | 30min | Analisa mercado, define estratégia |
| dev-implement-strategy | dev | 1h | Implementa estratégias do researcher |
| trader-monitor | trader | 15min | Monitora bot, reporta PnL |

---

## Instalação do zero

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

> ⚠️ **Importante:** rode sempre de dentro da pasta `my-openclaw` (onde fica o `.env`), pois o systemd usa `EnvironmentFile=$(pwd)/.env`.

---

## Troubleshooting

### Gateway cai logo após iniciar
O systemd precisa apontar para o `.env` correto:
```bash
cat /etc/systemd/system/openclaw.service | grep EnvironmentFile
```
Se o caminho estiver errado, corrija:
```bash
# dentro da pasta do projeto:
sed -i "s|EnvironmentFile=.*|EnvironmentFile=$(pwd)/.env|" /etc/systemd/system/openclaw.service
systemctl daemon-reload && systemctl restart openclaw
```

### Warnings de "missing env var" no CLI
Normal — o terminal local não tem as vars. O gateway via systemd funciona corretamente. Para suprimir localmente:
```bash
set -a; source .env; set +a
```

### Processo órfão travando o gateway
```bash
pkill -f "openclaw-gateway" && systemctl restart openclaw
```

### Ver logs do gateway
```bash
journalctl -fu openclaw
```

---

## Backup e restore

Arquivos críticos salvos neste repo:

```
config/identity-friday.md     → personalidade da Friday (main)
config/identity-researcher.md → personalidade do researcher
config/identity-dev.md        → personalidade do dev
config/identity-trader.md     → personalidade do trader
.env.example                  → template das chaves de API
setup.sh                      → script de instalação completa
```

Para restaurar em nova máquina:
```bash
git clone https://github.com/lsventura/my-openclaw.git
cd my-openclaw
cp .env.example .env  # preenche as chaves
bash setup.sh
```
