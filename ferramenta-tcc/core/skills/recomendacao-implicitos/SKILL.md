---
name: recomendacao-implicitos
description: Sugere RFs/RNFs implícitos (o "óbvio não-dito") usando os catálogos rfs-tipicos.md e rnfs-tipicos.md com algoritmo de filtragem em 3 camadas (D-S4.3) para produzir 5–10 candidatos em vez de 38. Confirma com o usuário em 1 lote de 4 perguntas. Referência: Livro SON §4.4.
when_to_use: Invocada pelo collector na Ronda 4 da Fase A. Sempre executar após recomendacao-dominio. 1 chamada AskUserQuestion com até 4 perguntas de confirmação.
---

# Skill: recomendacao-implicitos

**Referências:** Livro SON §4.4 (implícitos) · `catalogos-seed/rfs-tipicos.md` · `catalogos-seed/rnfs-tipicos.md`
**Marco:** M2 — Consenso de Escopo (Fase A, Ronda 4)
**Invocada por:** `collector`

---

## OBJETIVO

Capturar o "óbvio não-dito" — funcionalidades e comportamentos que o usuário assume como garantidos mas não menciona explicitamente. Exemplo: numa loja virtual, o usuário menciona "carrinho de compras" mas não menciona "confirmação por e-mail do pedido" — isso é implícito.

---

## PROCESSAMENTO — ALGORITMO DE FILTRAGEM EM 3 CAMADAS (D-S4.3)

### Entrada

- `catalogos-seed/rfs-tipicos.md` (RFs genéricos por categoria)
- `catalogos-seed/rnfs-tipicos.md` (RNFs por bucket de qualidade)
- `elicitacao-raw.md` (acumulado até a Ronda 3)
- `visao-produto-normativo.md` (contexto)

### Camada 1 — Eliminar categorias já cobertas

Para cada categoria do catálogo (`rfs-tipicos.md`):
1. Verificar se `visao-produto-normativo.md` ou `elicitacao-raw.md` já menciona itens desta categoria
2. Se a categoria está suficientemente coberta (≥ 2 itens confirmados): **pular a categoria inteira**
3. Manter apenas categorias com cobertura zero ou parcial (≤ 1 item confirmado)

**Objetivo:** reduzir de todas as categorias do catálogo para apenas as que ainda têm lacunas.

### Camada 2 — Eliminar itens já elicitados

Dentro das categorias restantes:
1. Para cada item do catálogo, verificar se já aparece em `elicitacao-raw.md` (por texto similar ou equivalente)
2. Se aparece: **pular o item**
3. Manter apenas itens genuinamente ausentes

**Objetivo:** evitar perguntar sobre o que o usuário já confirmou.

### Camada 3 — Priorizar por relevância

Dos itens restantes após as Camadas 1 e 2:
1. Itens marcados com ⭐ no catálogo (alta frequência universal): incluir sempre
2. Itens que fazem match com o domínio confirmado pela `recomendacao-dominio`: incluir
3. Itens de domínio diferente do projeto: excluir
4. Selecionar top 5–10 itens por prioridade decrescente (⭐ primeiro, depois match de domínio)

**Objetivo:** apresentar ao usuário apenas os candidatos mais relevantes — não todos os 38 itens do catálogo.

---

## CONSTRUÇÃO DAS PERGUNTAS

Com os 5–10 candidatos filtrados, montar 1 lote de até 4 perguntas de confirmação:

### Estratégia de agrupamento

- Agrupar candidatos similares numa mesma pergunta (choice com múltiplas opções)
- Máximo 4 perguntas no lote (D14)
- Preferir choice sobre yesno (permite confirmar múltiplos itens de uma vez)

### Exemplo de pergunta agrupada

```
Destas funcionalidades comuns que ainda não mencionamos, quais fariam sentido para o seu produto?
(Pode marcar mais de uma)
(A) Confirmação por e-mail após ação do usuário (ex: compra, cadastro, pedido)
(B) Recuperação de senha / acesso esquecido
(C) Histórico de atividades do usuário
(D) Nenhuma dessas por enquanto
```

### Pré-aviso obrigatório antes do lote

Apresentar ao usuário antes de invocar `AskUserQuestion`:
> "Agora vou sugerir algumas funcionalidades que sistemas como o seu costumam precisar — você me diz se fazem sentido para o seu projeto."

(Aplicar `traducao-leigo` sobre o pré-aviso antes de exibir)

---

## REGISTRO NO elicitacao-raw.md

```markdown
## Implícitos Confirmados (recomendacao-implicitos — Fase A)

**Catálogos consultados:**
- `catalogos-seed/rfs-tipicos.md` — categorias verificadas: [lista]
- `catalogos-seed/rnfs-tipicos.md` — buckets verificados: [lista]

**Itens filtrados (antes da confirmação):** [N candidatos de um total de X no catálogo]

**Itens confirmados pelo usuário:**
- RF-IMPL-001: [descrição] — origem: `rfs-tipicos.md`, categoria [X], item [Y]
- RNF-IMPL-001: [descrição] — origem: `rnfs-tipicos.md`, bucket [Z]

**Itens rejeitados pelo usuário:** [lista resumida — para referência futura]
```

---

## REGRAS (D14 + D19)

- 1 única chamada AskUserQuestion com ≤ 4 perguntas
- Proibido perguntar sobre mais de 10 candidatos no total (resultado do filtro de 3 camadas)
- Proibido mencionar "catálogo", "implícito", "seed", "requisito" ao usuário
- Usar linguagem: "funcionalidades que sistemas como o seu costumam precisar" em vez de "requisitos implícitos"
- Rastrear origem: cada item confirmado deve ter referência ao catálogo + categoria + item de origem

---

## SAÍDA

Seção adicionada a `elicitacao-raw.md` com candidatos filtrados + confirmação do usuário + rastreabilidade de origem.
