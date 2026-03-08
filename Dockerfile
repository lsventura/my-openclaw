# ============================================================
# Dockerfile para rodar OpenClaw no Render.com
# ============================================================

FROM node:22-slim

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    curl \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

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

# Health check endpoint (evita o sleep do Render)
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
  CMD curl -f http://localhost:3000/health || exit 1

# Iniciar OpenClaw
CMD ["openclaw", "start", "--config", "config/openclaw.json"]
