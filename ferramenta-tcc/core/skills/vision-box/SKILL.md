---
name: vision-box
description: >-
  Captura a essência do produto em linguagem de negócio — primeira pergunta sobre o que o usuário quer construir.
  Use quando o usuário descreve o produto pela primeira vez ou ao iniciar o projeto.
  Capture product vision for a layperson stakeholder; map name, audience, benefit, and differentiator.
---

## Filosofia desta skill (Regras Absolutas)

1. **Facilitador gentil** — nunca pressiono, nunca julgo. Cada resposta é válida; meu papel é expandir, não corrigir.
2. **Resposta vaga não é informação.** Se o usuário diz "para todo mundo" ou "quero ganhar dinheiro", ofereço 2–3 opções concretas via `choice` antes de prosseguir.
3. **Zero jargão de produto.** Nunca menciono "Vision Box", "técnica", "metodologia", "requisito" — essas palavras não existem para o usuário (D1).

<HARD-GATE>
- NÃO executar se `visao-produto.md` já contém seção `## Visão do Produto` (idempotência — evitar duplicação)
- ⛔ STOP e registrar em `_pendencias.md` se o usuário pular nome E benefício principal simultaneamente (campos mínimos para síntese)
</HARD-GATE>

## Fase 0 — Inicialização

1. Carregar `core/constitution.md` (guardrail D1 + Output Discipline)
2. Verificar `estado-projeto.yaml`; se ausente: inicializar com `marco_corrente: M1`
3. Checar idempotência: se `## Visão do Produto` já existe em `visao-produto.md`, pular para Fase 3 (sinalização)

## Fase 1 — Coleta

Coletar TODAS antes de invocar `AskUserQuestion` (D14 — batching obrigatório, máx 4 perguntas).

**Lote Vision Box:**

1. **Nome do produto** (text):
   ```
   Como você chamaria esse produto? Pode ser um nome definitivo ou um apelido por enquanto.
   ```

2. **Público-alvo** (text):
   ```
   Quem vai usar esse produto? Pense nas pessoas que mais vão se beneficiar com ele.
   ```

3. **Principal benefício** (text):
   ```
   Qual é o maior benefício que seu produto oferece? Se você tivesse que convencer alguém em uma frase, o que diria?
   ```

4. **Diferencial** (text):
   ```
   Por que alguém escolheria esse produto em vez de fazer a mesma coisa de outro jeito (manualmente, com outra ferramenta, etc.)?
   ```

## Fase 2 — Síntese

Montar bloco Vision Box com as respostas:

```markdown
## Visão do Produto

**Nome:** [resposta 1]

**Para:** [resposta 2 — público-alvo]

**Que:** [síntese do problema/necessidade inferida das respostas]

**O [nome do produto] é:** [classificação em linguagem natural — ex: "uma plataforma online", "um aplicativo móvel"]

**Que:** [principal benefício — resposta 3]

**Diferente de:** [como fazem hoje — inferido da resposta 4]

**Nosso produto:** [diferencial — resposta 4 reformulada]
```

**Regras de síntese:**

- Inferir classificação do produto (app, plataforma, sistema) do contexto — não perguntar explicitamente
- Se "como fazem hoje" não ficar claro pela resposta 4: usar "processo manual" como fallback
- Aplicar `traducao-leigo` antes de qualquer exibição ao usuário (D1)
- Se resposta 2 ou 3 for genérica (≤ 5 palavras ou keywords: "útil", "ganhar", "todo mundo", "melhorar"): oferecer opções choice antes de sintetizar

## Fase 3 — Saída

1. Append seção `## Visão do Produto` em `visao-produto.md` (criar arquivo se inexistente)
2. Registrar em `estado-projeto.yaml`:
   ```yaml
   artefatos:
     - nome: visao-produto.md
       marco: M1
       iteracao: 1
   ```
3. Sinalizar ao `stakeholder-identifier`: Vision Box concluído → prosseguir para `situacao-problema`

<!-- internal -->
## Anti-Padrão: Benefício Genérico Não Sondado

**Como acontece:** Usuário responde "Quero que o produto seja útil" ou "Para ganhar mais dinheiro". A síntese aceita a resposta literal e o campo "Que:" fica vazio de significado.

**Como detectar:** Resposta 3 tem ≤ 5 palavras OU contém keywords: "útil", "ganhar", "todo mundo", "melhorar", "ajudar".

**O que fazer:** Re-perguntar via `choice` com exemplos concretos do domínio inferido. Exemplo: "Qual desses se aproxima mais do benefício principal? (a) Economizar tempo no dia a dia; (b) Reduzir erros que causam prejuízo; (c) Ter visibilidade de algo difícil de acompanhar; (d) Outro."
<!-- /internal -->
