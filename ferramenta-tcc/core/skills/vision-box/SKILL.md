---
name: vision-box
description: >-
  Captura a essência do produto em linguagem de negócio — primeira pergunta sobre o que o usuário quer construir.
  Use quando o usuário descreve o produto pela primeira vez ou ao iniciar o projeto.
  Capture product vision for a layperson stakeholder; map name, audience, benefit, and differentiator.
---

## Como invocar perguntas (regra absoluta)

SEMPRE usar tool call estruturado `ask_user` (Gemini) / `AskUserQuestion` (Claude).
NUNCA escrever as perguntas como prosa no chat. NUNCA encadear múltiplas perguntas em uma frase.
Cada sub-lote = 1 tool call com seus campos separados.

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

Coletar em 2 sub-lotes sequenciais. Cada sub-lote = 1 tool call `ask_user`/`AskUserQuestion`. Nunca comprimir em prosa.

**Sub-lote A — Identificação** (sempre — 1 tool call, 2 perguntas text):

1. **Nome do produto** (text):
   ```
   Como você chamaria esse produto? Pode ser um nome definitivo ou um apelido por enquanto.
   ```

2. **Público-alvo** (text):
   ```
   Quem vai usar esse produto? Pense nas pessoas que mais vão se beneficiar com ele.
   ```

**Sub-lote B — Proposta de valor** (após resposta do Sub-lote A — 1 tool call, 2 perguntas):

3. **Principal benefício** (text — mas apresentar também opção choice de pular):
   ```
   Em uma frase: qual o maior benefício do seu produto?
   ```
   Opção choice visível: `"Ainda não pensei nisso — me ajude a descobrir depois"`
   Se usuário escolher essa opção: registrar `vision-box: benefício pendente` em `_pendencias.md`; slot = `[a definir]`

4. **Diferencial** (text — mas apresentar também opção choice de pular):
   ```
   O que faz seu produto diferente do que já existe? (pode ser bem informal)
   ```
   Opção choice visível: `"Ainda não pensei nisso — me ajude a descobrir depois"`
   Se usuário escolher essa opção: registrar `vision-box: diferencial pendente` em `_pendencias.md`; slot = `[a definir]`

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

## Fase 2.5 — Inferência de slots pendentes (condicional)

Executada ANTES do `traducao-gate`, após situacao-problema + stakeholder-mapping + contexto-e-limite terem coletado contexto.

SE `_pendencias.md` contém `vision-box: benefício pendente` OU `vision-box: diferencial pendente`:

1. Ler contexto coletado pelas skills anteriores
2. Tentar inferir o slot pendente do contexto disponível
3. Apresentar inferência via `ask_user`/`AskUserQuestion` (3 opções):
   ```
   Pelo que conversamos, o maior benefício do [nome] parece ser: [síntese inferida]. Confirma?
   ```
   Opções: `"Sim, é isso"` / `"Não, eu explico melhor"` / `"Ainda não consigo dizer"`
4. Se "Sim": atualizar slot, remover pendência do `_pendencias.md`
5. Se "Não, eu explico melhor": coletar text, atualizar slot, remover pendência
6. Se "Ainda não consigo dizer" OU inferência impossível: manter `[a definir]`
   - Versão normativa: `[a definir — a elicitar em iteração futura]`
   - Versão leigo: omitir o campo

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
