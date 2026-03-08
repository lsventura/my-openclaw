# Guia dos Agentes

## Amora (Boss Agent)
Agente principal. Toda mensagem no Telegram vai para ela primeiro.
Ela decide se resolve sozinha ou delega para um sub-agente.

**Como usar:**
- Mande qualquer tarefa diretamente
- Para forçar um agente específico: `@finance analise BTC hoje`
- Para resetar contexto: `/new`
- Para ver memória ativa: `/memory`

## FinanceBot
Especializado em cripto, trading, análise de mercado.

**Exemplos de uso:**
```
@finance Qual o preço do BTC agora?
@finance Analisa o top 5 altcoins da semana
@finance Me dá um relatório do meu bot de trading
```

## DevBot
Especializado em código Python, automações, debug.

**Exemplos de uso:**
```
@dev Cria um script Python para monitorar preço do BTC a cada 5min
@dev Debugar esse erro: [cole o erro]
@dev Como faço deploy do meu bot no Oracle Cloud?
```

## ResearchBot
Pesquisa web, análise de mercado, tendências.

**Exemplos de uso:**
```
@research Quais são os melhores nichos de impressão 3D em 2026?
@research Pesquisa oportunidades de FBA para produtos sensoriais no Brasil
@research Últimas notícias sobre regulamentação crypto no Brasil
```

## LifeBot
Assistente pessoal para vida cotidiana.

**Exemplos de uso:**
```
@life Cria uma lista de compras para Miami
@life Sugere um treino de costas e bíceps
@life Quais restaurantes bons em Key West para visitar em maio?
```

---

## Boas Práticas

1. **Use `/new` periodicamente** — evita acúmulo de contexto e lentidão
2. **Seja específico** — "analise BTC" é melhor que "me fala de cripto"
3. **Deixe os agentes atualizarem o workspace** — isso melhora a memória
4. **Comece com 1 agente** — suba só o Boss primeiro, adicione outros depois
