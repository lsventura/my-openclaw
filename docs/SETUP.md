# Guia Completo de Setup

## Pré-requisitos

- Conta no [Oracle Cloud Free Tier](https://oracle.com/cloud/free) (grátis)
- Conta no [OpenRouter](https://openrouter.ai) (grátis)
- Bot criado no Telegram via [@BotFather](https://t.me/BotFather)
- Conta no GitHub com este repositório

---

## Passo 1 — Criar VM no Oracle Cloud

1. Acesse [cloud.oracle.com](https://cloud.oracle.com) e faça login
2. Vá em **Compute → Instances → Create Instance**
3. Configure:
   - **Shape**: `VM.Standard.A1.Flex` (ARM — Always Free)
   - **OCPUs**: 2 | **RAM**: 12 GB (limite free: 4 OCPUs / 24 GB total)
   - **OS**: Ubuntu 22.04 (ARM)
   - **Storage**: 50 GB (free até 200 GB)
4. Em **Networking**: crie uma VCN nova se não tiver
5. Em **SSH Keys**: faça upload da sua chave pública ou gere uma
6. Clique em **Create**
7. Aguarde ~2 min e anote o **IP público**

### Abrir portas necessárias
No painel Oracle: **Networking → VCN → Security Lists → Ingress Rules**
```
Protocol: TCP  |  Port: 3000  |  Source: 0.0.0.0/0  (OpenClaw gateway)
Protocol: TCP  |  Port: 22    |  Source: 0.0.0.0/0  (SSH)
```

No servidor (firewall interno do Ubuntu):
```bash
sudo iptables -I INPUT -p tcp --dport 3000 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT
```

---

## Passo 2 — Conectar via SSH

```bash
ssh ubuntu@SEU_IP_ORACLE
```

---

## Passo 3 — Obter suas chaves

### Telegram Bot Token
1. Abra o Telegram → pesquise `@BotFather`
2. `/newbot` → dê um nome → obtenha o token
3. Para obter seu User ID: fale com `@userinfobot`

### OpenRouter API Key (gratuito)
1. Acesse [openrouter.ai](https://openrouter.ai)
2. Crie conta com Google → vá em **Keys → Create Key**
3. Copie a chave `sk-or-v1-...`
4. Modelos gratuitos disponíveis:
   - `moonshotai/kimi-k2` ✅
   - `google/gemini-2.0-flash-exp:free` ✅
   - `meta-llama/llama-3.3-70b-instruct:free` ✅
   - `deepseek/deepseek-chat:free` ✅

---

## Passo 4 — Instalar

```bash
# No servidor Oracle, clone o repositório
git clone https://github.com/lsventura/my-openclaw.git
cd my-openclaw

# Rode o script de instalação
bash scripts/install.sh

# Preencha as chaves
nano .env
```

---

## Passo 5 — Iniciar o sistema

```bash
# Iniciar OpenClaw com sua configuração
openclaw start --config config/openclaw.json

# Verificar status
openclaw status

# Ver logs em tempo real
tail -f /var/log/openclaw/openclaw.log
```

---

## Passo 6 — Testar no Telegram

Abra seu bot no Telegram e envie:
```
Oi Amora, estou online!
```

Se responder, o sistema está funcionando. 🎉

---

## Comandos Úteis

```bash
openclaw status            # Status dos agentes
openclaw daemon restart    # Reiniciar
openclaw logs --agent boss # Logs de um agente
bash scripts/backup.sh     # Backup manual da memória
bash scripts/update.sh     # Atualizar o sistema
```

---

## Agendar Backup Automático

```bash
crontab -e
# Adicionar linha:
0 3 * * * bash ~/my-openclaw/scripts/backup.sh
```

---

## Troubleshooting

| Problema | Solução |
|---|---|
| Bot não responde | Verificar `TELEGRAM_BOT_TOKEN` no `.env` |
| Erro de modelo | Trocar para outro modelo free no `config/openclaw.json` |
| Memória consumindo muito | Rodar `/new` no Telegram para resetar sessão |
| VM Oracle lenta | Limitar agentes ativos para 2-3 simultâneos |
