# Memória Longa — Amora (Boss)

> Arquivo de memória persistente. Atualizado automaticamente no flush.
> Última atualização: 2026-03-14

## DECISÕES
- [2026-03] Decidiu usar OpenClaw como sistema central de agentes IA pessoais
- [2026-03] Escolheu Oracle Cloud Free Tier como servidor principal
- [2026-03] Optou por modelos gratuitos via OpenRouter para reduzir custo
- [2026-03] Definiu Amora como agente primário no canal Telegram

## PROJETOS — Estado Atual
- **OpenClaw**: configurando ambiente; sandbox estava sem acesso real → corrigido
- **Crypto Bot**: planejamento de bot Solana/arbitragem em andamento; DevBot envolvido
- **3D Printing**: negócio em desenvolvimento, foco em brinquedos sensoriais
- **Inglês**: aprendizado formal em progresso

## LIÇÕES APRENDIDAS
- Sobrescrever openclaw.json sem preservar a seção `channels` derruba o Telegram
- Sandbox padrão do OpenClaw não herda envs do host — precisam ser declarados explicitamente em `docker.env`
- A chave correta para o canal Telegram é `channels.telegram.botToken`, não `telegram.token`

## BLOQUEIOS ATIVOS
- Nenhum bloqueio ativo no momento

## FATOS-CHAVE DO USUÁRIO
- Nome: Leonardo Ventura
- Cidade: São Paulo, Brasil
- Perfil: desenvolvedor, empreendedor, trader
- Stack principal: Python, PostgreSQL, LangChain, Binance API, Telegram
- Servidor: Oracle Cloud Free Tier (ARM)
- Horário de trabalho: tarde/noite/madrugada
- Objetivos: renda passiva via cripto bot + negócio de impressão 3D
- Idioma preferido: português brasileiro (está aprendendo inglês)

## PENDÊNCIAS
- Validar que Telegram voltou a funcionar após correção do openclaw.json
- Configurar variável BINANCE_API_KEY no .env do servidor
- Criar workspace/projects/crypto_bot.md com detalhes do bot Solana
