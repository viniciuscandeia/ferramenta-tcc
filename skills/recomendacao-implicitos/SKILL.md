---
name: recomendacao-implicitos
marco: [M2]
description: >-
  Sugere funcionalidades que sistemas similares costumam ter mas que o usuário não mencionou — o "óbvio não-dito".
  Use na Rodada 4 do Marco 2, após confirmar o tipo de produto com o usuário.
  Implicit requirement recommendation for layperson stakeholder; uses 3-layer filtering to present only 5-10 relevant candidates.
---

## Filosofia desta skill (Regras Absolutas)

1. **O "óbvio não-dito" existe em todo projeto.** Ninguém menciona "recuperação de senha" porque assume que é automático. Esta skill torna o implícito explícito — e confirmado.
2. **Filtragem 3 camadas é obrigatória.** Apresentar o catálogo completo de 38 itens ao usuário é sobrecarga cognitiva. O algoritmo produz 5–10 candidatos. Sem exceção.
3. **Rastrear origem de cada item confirmado.** Cada RF/RNF confirmado deve ter referência ao catálogo + categoria + item — a rastreabilidade começa aqui.

<HARD-GATE>
- NÃO executar antes de `recomendacao-dominio` concluída (verificar seção `## Recomendações de Domínio` em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`)
- NÃO executar se `content/catalogos-seed/rfs-tipicos.md` ou `rnfs-tipicos.md` não estiverem acessíveis — registrar em `_pendencias.md` e pular
- ⛔ STOP se algoritmo de filtragem 3 camadas produz 0 candidatos após Camadas 1+2+3 — registrar "projeto atípico, sem implícitos do catálogo" e pular para `questionario-feixe`
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar pré-condição: `## Recomendações de Domínio` existe em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`
3. Acessar `content/catalogos-seed/rfs-tipicos.md` + `content/catalogos-seed/rnfs-tipicos.md`

## Fase 1 — Algoritmo de Filtragem (3 Camadas)

**Entrada:** `content/catalogos-seed/rfs-tipicos.md`, `rnfs-tipicos.md`, `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` acumulado, `documentos-tecnicos/01-visao/01-visao-produto.md`.

**Camada 1 — Eliminar categorias já cobertas:**
Para cada categoria do catálogo: se ≥ 2 itens confirmados em `documentos-tecnicos/01-visao/01-visao-produto.md` ou `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` → pular categoria inteira.
Manter apenas categorias com cobertura zero ou parcial (≤ 1 item confirmado).

**Camada 2 — Eliminar itens já elicitados:**
Dentro das categorias restantes: para cada item, verificar se já aparece em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md` (por texto similar ou equivalente). Se aparece → pular o item.

**Camada 3 — Priorizar por relevância:**
Dos itens restantes:
1. Itens marcados ⭐ no catálogo (alta frequência universal): incluir sempre
2. Itens com match no domínio confirmado pela `recomendacao-dominio`: incluir
3. Itens de domínio diferente: excluir
4. Selecionar top 5–10 por prioridade decrescente (⭐ primeiro, depois match de domínio)

## Fase 2 — Construção das Perguntas

Com os 5–10 candidatos filtrados, montar 1 lote de até 4 perguntas. Agrupar candidatos similares numa pergunta `multi-choice` com `multiSelect: true` (confirmar múltiplos de uma vez).

**Pré-aviso obrigatório antes do lote** (aplicar `traducao-leigo`):
> "Agora vou sugerir algumas funcionalidades que sistemas como o seu costumam precisar — você me diz se fazem sentido para o seu projeto."

**Exemplo de pergunta agrupada:**
```
Destas funcionalidades que ainda não mencionamos, quais fariam sentido para o seu produto?
(Pode marcar mais de uma)
(A) Confirmação por e-mail após ação do usuário (ex: compra, cadastro, pedido)
(B) Recuperação de senha / acesso esquecido
(C) Histórico de atividades do usuário
(D) Nenhuma dessas por enquanto
```
`multiSelect: true` — usuário pode confirmar múltiplos implícitos de uma vez.

## Fase 3 — Coleta

1 única chamada `AskUserQuestion` com ≤ 4 perguntas (D14).

## Fase 4 — Saída

Acrescentar seção em `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`:

```markdown
## Implícitos Confirmados (recomendacao-implicitos — Fase A)

**Catálogos consultados:**
- `content/catalogos-seed/rfs-tipicos.md` — categorias verificadas: [lista]
- `content/catalogos-seed/rnfs-tipicos.md` — buckets verificados: [lista]

**Itens filtrados (antes da confirmação):** [N candidatos de um total de X no catálogo]

**Itens confirmados pelo usuário:**
- RF-IMPL-001: [descrição] — origem: `rfs-tipicos.md`, categoria [X], item [Y]
- RNF-IMPL-001: [descrição] — origem: `rnfs-tipicos.md`, bucket [Z]

**Itens rejeitados pelo usuário:** [lista resumida]
```

Sinalizar ao `collector`: recomendacao-implicitos concluída → prosseguir para `questionario-feixe` (se condição atendida) ou encerrar Fase A.

<!-- internal -->
## Anti-Padrão: Lista Completa do Catálogo Sem Filtragem

**Como acontece:** A skill pula as Camadas 1 e 2 por "eficiência" e apresenta os 38 itens do catálogo genérico em 10 perguntas. Usuário responde "sim" para metade por exaustão ou confusão — `elicitacao-raw.md` fica inflado com RFs irrelevantes.

**Como detectar:** Se o número de candidatos antes da Fase 2 > 10, a filtragem falhou. Verificar contagem antes de construir perguntas.

**O que fazer:** Reexecutar Camadas 1+2+3. Se ainda > 10 após 3 camadas, aplicar corte hard: top 10 por prioridade de camada. Nunca apresentar > 10 candidatos em 4 perguntas.
<!-- /internal -->
