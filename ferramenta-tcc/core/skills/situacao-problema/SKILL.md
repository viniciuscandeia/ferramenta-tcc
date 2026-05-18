---
name: situacao-problema
description: >-
  Documenta o problema central do projeto com tabela de 6 slots — o que está errado, quem sofre, qual o impacto e o que seria uma solução.
  Use após capturar a visão do produto, quando o usuário precisa detalhar o problema que quer resolver.
  Document the core problem statement for a layperson stakeholder; fills 6-slot problem table.
---

## Filosofia desta skill (Regras Absolutas)

1. **Âncora do projeto** — tudo que será levantado nas fases seguintes deve conectar a esta declaração. Se ficar raso aqui, todo o restante paga o preço.
2. **Slot vazio = inferir com flag `[inferido]`, nunca deixar branco.** Informação marcada como inferida é rastreável; branco é invisível.
3. **Resposta vaga no slot de impacto não passa.** "É ruim" ou "causa problemas" não é impacto — sondar sempre com "Quais são as consequências concretas? O que acontece de errado?" antes de registrar.

<HARD-GATE>
- NÃO executar antes de `vision-box` concluído (verificar que `## Visão do Produto` existe em `visao-produto.md`)
- ⛔ STOP após Lote 1 se ≥ 2 respostas retornarem vazias ou monossilábicas — registrar em `_pendencias.md` e solicitar retomada
</HARD-GATE>

## Fase 0 — Inicialização

1. Carregar `core/constitution.md` (guardrail D1 + Output Discipline)
2. Verificar pré-condição: `## Visão do Produto` deve existir em `visao-produto.md`
3. Extrair do Vision Box: público-alvo e nome do produto (usados para personalizar perguntas de Lote 2)

## Fase 1 — Lote 1 (O Problema)

Coletar TODAS antes de invocar `AskUserQuestion` (D14 — batching, máx 4 perguntas).

**Lote 1 — O problema:**

1. **O problema** (text):
   ```
   O que exatamente está errado hoje? Descreva a dificuldade que seu produto vai resolver.
   ```

2. **Quem sofre o problema** (text):
   ```
   Quem sofre mais com essa dificuldade? Pode ser um tipo de pessoa, uma equipe, um grupo.
   ```

3. **Impacto do problema** (text):
   ```
   O que acontece por causa desse problema? Quais são as consequências ruins de não resolvê-lo?
   ```

4. **Solução esperada** (text):
   ```
   Qual seria a solução ideal? Não precisa ser técnico — só descreva o que você espera que o produto faça.
   ```

## Fase 2 — Lote 2 (Usuários e Funcionalidades)

**Lote 2 — Usuários e funcionalidades:**

5. **Usuários principais** (text):
   ```
   Quem vai usar o produto no dia a dia? Liste os tipos de pessoas (ex: cliente, gerente, atendente).
   ```

6. **O que o produto precisa fazer** (text):
   ```
   Cite as 3 ou 4 coisas mais importantes que o produto precisa fazer para resolver o problema.
   ```

## Fase 3 — Síntese

Gerar tabela de situação-problema:

```markdown
## Situação-Problema

| Slot | Conteúdo |
|---|---|
| O problema de | [resposta 1] |
| Afeta | [resposta 2] |
| Cujo impacto é | [resposta 3] |
| Uma solução bem-sucedida seria | [resposta 4] |
| Os usuários principais são | [resposta 5] |
| As principais funcionalidades são | [resposta 6 — lista bullet] |
```

**Regras de síntese:**

- Slot vazio ou vago: inferir com base nas outras respostas e marcar como `[inferido]` na versão normativa
- Funcionalidades: converter resposta 6 em lista de bullet points concisos
- Verificar alinhamento com Vision Box: usuários da situação-problema devem coincidir com público-alvo da Vision Box; divergência → registrar nota de verificação
- Aplicar `traducao-leigo` antes de qualquer exibição ao usuário (D1)

## Fase 4 — Saída

1. Append seção `## Situação-Problema` em `visao-produto.md`
2. Atualizar `estado-projeto.yaml` (incrementar `iteracao` se já existia entrada)
3. Sinalizar ao `stakeholder-identifier`: situação-problema concluída → prosseguir para `stakeholder-mapping`

<!-- internal -->
## Anti-Padrão: Usuários Duplicam Público-Alvo

**Como acontece:** Slot "usuários principais" (resposta 5) é preenchido com exatamente as mesmas pessoas do Vision Box "público-alvo" (resposta 2), sem distinção entre quem usa e quem decide ou paga.

**Como detectar:** Overlap ≥ 90% entre resposta 2 (Vision Box) e resposta 5 desta skill. Exemplo: Vision Box diz "donos de pequenas lojas" e resposta 5 diz "donos de loja".

**O que fazer:** Re-elicitar nuance — sondar se há diferença entre quem usa o produto no dia a dia e quem aprova a compra ou paga. Pergunta de sondagem: "Além de [usuário já mencionado], tem alguém que precisa aprovar ou pagar pelo produto, mesmo sem usá-lo diretamente?"
<!-- /internal -->
