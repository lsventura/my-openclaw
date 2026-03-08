# ============================================================
# Dockerfile para rodar OpenClaw no Render.com
# Free tier: 512 MB RAM — Node heap limitado a 384 MB
# ============================================================

FROM node:22-slim

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Limitar heap do Node.js para caber no free tier (512MB RAM)
ENV NODE_OPTIONS="--max-old-space-size=384"

# Instalar OpenClaw globalmente
RUN npm install -g openclaw

# Diretório de trabalho
WORKDIR /app

# Copiar arquivos do projeto
COPY . .

# Criar diretório de logs
RUN mkdir -p /var/log/openclaw

# Expor porta do gateway
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
  CMD curl -f http://localhost:3000/health || exit 1

# Iniciar OpenClaw com limite explícito de memória
CMD ["node", "--max-old-space-size=384", "/usr/local/lib/node_modules/openclaw/bin/openclaw.js", "start", "--config", "config/openclaw.json"]
