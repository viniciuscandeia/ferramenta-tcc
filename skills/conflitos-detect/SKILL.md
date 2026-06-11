---
name: conflitos-detect
marco: [M2]
description: >-
  Verifica se há contradições, duplicatas ou inconsistências entre os itens levantados — e registra cada problema com estratégia de resolução.
  Use no Marco 2, após priorizar e construir o glossário, antes de verificar o que ainda está pendente.
  Detect conflicts between requirements and stakeholders per IREB §4.4; runs 5 checks automatically; no user interaction.
---

## Filosofia desta skill (Regras Absolutas)

1. **Crítico de consistência** — 5 verificações sempre, na ordem definida. Pular uma verificação porque "o projeto é simples" = falsa segurança. Conflito não detectado em M2 vira CRITICAL em `analyze-cross-artifact` (M3).
2. **Falso positivo = pauta, não silêncio.** Incerto se é conflito real? Registrar como CONF com status `a-verificar`. Melhor 1 pauta desnecessária do que 1 conflito ignorado.
3. **O modeler não resolve conflitos.** Registrar com estratégia recomendada; a decisão humana vem depois. Status inicial sempre `aberto`.

<HARD-GATE>
- NÃO executar antes de `priorizacao` e `glossario` concluídas
- NÃO executar se `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` não existe ou está vazio (nada para verificar)
- ⛔ STOP se qualquer arquivo de entrada estiver corrompido ou ilegível — registrar em `_pendencias.md` antes de prosseguir
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`, `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`, `documentos-tecnicos/02-requisitos/02.3-restricoes.md`, `documentos-tecnicos/01-visao/01-visao-produto.md`, `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`, `documentos-tecnicos/02-requisitos/02.5-glossario.md` acessíveis

## Fase 1 — 5 Verificações Sequenciais

**Tipos de conflito (IREB §4.4):**

| Tipo | Descrição | Sinal |
|---|---|---|
| **Interesse** | Stakeholders querem coisas opostas | RF-X favorece A mas prejudica B |
| **Dados** | Mesma informação definida diferente em dois lugares | "status" com valores diferentes em dois RFs |
| **Processo** | Fluxos incompatíveis | RF de fluxo A contradiz fluxo B |
| **Recursos** | Dois requisitos disputam recurso limitado | Alta disponibilidade vs. orçamento mínimo |
| **Valor** | Prioridades inconsistentes | Mesmo item `DEVE` em um lugar e `PODE` em outro |
| **Semântico** | Mesmo termo com sentidos diferentes por stakeholder | "cliente" = comprador vs. empresa contratante |

**Verificação 1 — Duplicatas:**
Dois IDs descrevendo a mesma funcionalidade com texto diferente? Candidatos: itens de fontes diferentes (entrevista vs. recomendacao-implicitos vs. recomendacao-dominio).

**Verificação 2 — Contradições escopo-limite:**
Um RF diz que o sistema FAZ X mas `documentos-tecnicos/01-visao/01-visao-produto.md` lista X como "fora do sistema"? Um RF implica integração com sistema externo não declarado em M1?

**Verificação 3 — Prioridades inconsistentes (conflito de Valor):**
Mesmo item tem `DEVE` em um lugar e `PODERIA` em outro? Item marcado `NAO_TERA` mas aparece como RF com modal em outro artefato?

**Verificação 4 — Conflito de interesse entre stakeholders:**
RF favorece fortemente um perfil e prejudica outro? Cruzar stakeholders de `documentos-tecnicos/01-visao/01-visao-produto.md` com RFs que os afetam.

**Verificação 5 — Conflitos semânticos:**
Cruzar `documentos-tecnicos/02-requisitos/02.5-glossario.md` com `documentos-tecnicos/02-requisitos/02-elicitacao-raw.md`: mesmo termo com definições diferentes em contextos distintos? Termos do glossário com `[DEFINIÇÃO INCERTA]` geram conflito potencial.

**Estratégias de resolução (IREB §4.4):**

| Estratégia | Quando usar |
|---|---|
| **Acordo** | Stakeholders podem dialogar e convergir |
| **Compromisso** | Nenhum lado cede totalmente — meio-a-meio |
| **Votação** | Múltiplos stakeholders com peso igual |
| **Análise de alternativas** | Nenhuma posição é possível — propor terceira opção |

## Fase 2 — Saída

**0 conflitos:** não criar `documentos-tecnicos/02-requisitos/02.7-conflitos-detectados.md`. Registrar na saída do modeler: "conflitos-detect: 0 conflitos em M2."

**≥ 1 conflito → criar `documentos-tecnicos/02-requisitos/02.7-conflitos-detectados.md`:**

```markdown
# Conflitos Detectados e Resolvidos — M2

> Conflitos não resolvidos podem bloquear Gate 3 (analyze-cross-artifact — D17).

---

## CONF-001 — [Tipo]: [Descrição curta]

**Tipo IREB §4.4:** [Interesse / Dados / Processo / Recursos / Valor / Semântico]
**Itens envolvidos:** RF-005, RF-012
**Descrição:** [O que está em conflito e por quê]
**Estratégia recomendada:** [Acordo / Compromisso / Votação / Análise de alternativas]
**Status:** `aberto`
**Resolução:** —
```

Conflito tipo Semântico com definição já em `documentos-tecnicos/02-requisitos/02.5-glossario.md` → pode marcar `resolvido` automaticamente.

Sinalizar ao `modeler`: conflitos-detect concluído → prosseguir para `pautas-reelicitacao` (Passo 5).

<!-- internal -->
## Anti-Padrão: Sinonímia Classificada como Conflito Semântico

**Como acontece:** "pedido" e "compra" são usados como sinônimos pelo usuário, mas o sistema os registra como 2 termos distintos e cria CONF-001 (conflito semântico). O modeler perde tempo gerenciando conflito que não existe.

**Como detectar:** Antes de criar conflito semântico, verificar campo "Sinônimos usados no projeto" no `02.5-glossario.md` para ambos os termos. Se um é sinônimo do outro: conflito não existe.

**O que fazer:** Cruzar `glossario.md` antes de registrar conflito semântico. Dois sinônimos = 1 verbete com 2 formas, não conflito. Criar CONF apenas se os termos têm definições genuinamente distintas para o mesmo referente.
<!-- /internal -->
