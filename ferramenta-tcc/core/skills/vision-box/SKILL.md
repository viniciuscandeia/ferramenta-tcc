---
name: vision-box
description: Captura a essência do produto em linguagem de negócio usando a técnica Vision Box — o usuário descreve o produto como se fosse a caixa de um produto de prateleira. Produz o primeiro componente de visao-produto.md.
when_to_use: Primeira skill do Marco 1, após saudação. Sempre executada antes de situacao-problema.
---

# Skill: vision-box

**Referência:** Material Dani `ers-apoio-marco-01-visao-do-produto.md`
**Marco:** M1 — Definição da Necessidade
**Ordem no workflow:** 1ª skill

---

## OBJETIVO

Capturar, em linguagem de negócio, a essência do que o usuário quer construir:
- Para quem é o produto
- Qual é o principal benefício
- Por que as pessoas vão querer usar

A metáfora da "caixa de produto" ajuda o usuário leigo a pensar no produto pelo ponto de vista do cliente, não da tecnologia.

---

## PERGUNTAS AO USUÁRIO

Coletar todas as perguntas antes de invocar `AskUserQuestion` (D14 — batching).

**Lote de perguntas Vision Box (máximo 4):**

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

---

## PROCESSAMENTO

Com as respostas do usuário, gerar o componente Vision Box:

### Estrutura Vision Box

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

### Regras de geração

- Inferir a classificação do produto (app, plataforma, sistema) a partir do contexto das respostas — não perguntar explicitamente (reduziria complexidade ao usuário)
- Se "como fazem hoje" não ficar claro pela resposta 4, inferir com "processo manual" como fallback
- Todo o texto deve estar em linguagem de negócio — aplicar `traducao-leigo` antes de exibir ao usuário
- Tom: positivo, focado no benefício, sem jargão técnico

---

## SAÍDA

Seção "## Visão do Produto" para compor `visao-produto.md`.

Sinalizar ao `stakeholder-identifier` que Vision Box concluído → prosseguir para `situacao-problema`.
