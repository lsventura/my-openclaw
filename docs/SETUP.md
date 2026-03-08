# Guia Completo de Setup

## Opções de Hospedagem
- [Render.com (recomendado — sem cartão)](#render) ⬅️ Siga este
- [Oracle Cloud Free Tier](#oracle) _(aprovação difícil para BR)_
- [Google Cloud e2-micro](#gcp)

---

<a name="render"></a>
## 🥇 Render.com (Sem cartão, deploy via GitHub)

### Pré-requisitos
- Conta no [OpenRouter](https://openrouter.ai) (grátis)
- Bot criado no Telegram via [@BotFather](https://t.me/BotFather)
- Este repositório no seu GitHub ✅ (já existe)

---

### Passo 1 — Obter suas chaves

#### Telegram Bot Token
1. Abra o Telegram → pesquise `@BotFather`
2. Digite `/newbot` → escolha um nome (ex: `MeuAssistenteBot`) → escolha um username terminando em `bot`
3. Copie o token gerado: `123456789:AAxxxxxxxxxxxxxxx`
4. Para obter seu **User ID numérico**: fale com [@userinfobot](https://t.me/userinfobot)

#### OpenRouter API Key (gratuito)
1. Acesse [openrouter.ai](https://openrouter.ai) → crie conta com Google
2. Vá em **Keys → Create Key** → copie a chave `sk-or-v1-...`
3. Modelos gratuitos configurados no projeto:
   - `moonshotai/kimi-k2` ✅ (Boss + Dev)
   - `google/gemini-2.0-flash-exp:free` ✅ (Finance + Research)
   - `meta-llama/llama-3.3-70b-instruct:free` ✅ (Life)

---

### Passo 2 — Criar conta no Render

1. Acesse [render.com](https://render.com)
2. Clique em **Get Started for Free**
3. Faça login com sua conta do **GitHub** (mais fácil)
4. Autorize o Render a acessar seus repositórios

---

### Passo 3 — Criar o Web Service

1. No dashboard do Render, clique em **New → Web Service**
2. Em **Connect a repository**, selecione `lsventura/my-openclaw`
3. Configure:

| Campo | Valor |
|---|---|
| **Name** | `my-openclaw` |
| **Region** | `Oregon (US West)` |
| **Branch** | `main` |
| **Runtime** | `Docker` |
| **Instance Type** | `Free` |

4. **Não clique em Deploy ainda** — primeiro adicione as variáveis de ambiente (próximo passo)

---

### Passo 4 — Variáveis de Ambiente

Ainda na tela de criação, role até **Environment Variables** e adicione:

| Key | Value |
|---|---|
| `TELEGRAM_BOT_TOKEN` | seu token do @BotFather |
| `TELEGRAM_USER_ID` | seu ID numérico do Telegram |
| `OPENROUTER_API_KEY` | `sk-or-v1-...` |

5. Agora clique em **Create Web Service**
6. Aguarde o build (~3-5 minutos na primeira vez)

---

### Passo 5 — Resolver o problema do Sleep

O Render free dorme após **15 minutos sem requisição**. Para manter o bot sempre acordado:

1. Após o deploy, copie a URL do seu serviço (ex: `https://my-openclaw.onrender.com`)
2. Acesse [cron-job.org](https://cron-job.org) → crie conta gratuita
3. **New Cronjob**:
   - URL: `https://my-openclaw.onrender.com/health`
   - Schedule: **Every 10 minutes**
4. Salve — isso pinga o serviço a cada 10 min, impedindo o sleep

---

### Passo 6 — Testar

Abra seu bot no Telegram e envie:
```
Oi Amora, estou online!
```

Se responder, está funcionando. 🎉

---

### Troubleshooting Render

| Problema | Solução |
|---|---|
| Build falhou | Verifique logs no painel Render → Build Logs |
| Bot não responde | Confirme `TELEGRAM_BOT_TOKEN` nas env vars |
| Serviço dormindo mesmo com ping | Aumente frequência do cron para 5 min |
| `Cannot find module openclaw` | O Dockerfile instala automaticamente — rebuilde |
| Memória cheia (512 MB limit) | Use só 1-2 agentes no free tier |

---

### Limitações do Render Free

- ⚠️ **512 MB RAM** — rode só Boss + 1 agente especializado inicialmente
- ⚠️ **750h/mês** — suficiente para 1 serviço rodando 24/7
- ⚠️ **Sem disco persistente** — a memória dos agentes some ao redeploy. Use o script de backup para salvar no GitHub (ver `scripts/backup_to_git.sh`)
- ✅ **Deploy automático** a cada push no `main`

---

### Estratégia para RAM limitada (512 MB)

Edite `config/openclaw.json` e deixe só o Boss ativo inicialmente:

```json
"list": [
  { "id": "boss", "name": "Amora", "config_file": "agents/boss.yaml", "primary": true }
]
```

Adicione os outros agentes um a um conforme necessidade.

---

<a name="gcp"></a>
## Google Cloud e2-micro (Always Free, cartão necessário)

1. [cloud.google.com/free](https://cloud.google.com/free) → criar conta
2. Compute Engine → Create VM → Shape: `e2-micro` → Region: `us-east1` → Ubuntu 22.04
3. Grátis para sempre (30 GB disco, 1 GB RAM, 0.25 vCPU)
4. Conectar via SSH e rodar `bash scripts/install.sh`

---

<a name="oracle"></a>
## Oracle Cloud (Always Free, aprovação difícil no Brasil)

Consulte a versão anterior deste guia caso consiga aprovação.
Shape recomendado: `VM.Standard.A1.Flex` (2 OCPUs / 12 GB RAM).
