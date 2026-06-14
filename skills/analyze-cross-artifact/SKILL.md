---
name: analyze-cross-artifact
disallowed-tools: [WebFetch, WebSearch, NotebookEdit]
marco: [M3]
description: Valida consistência entre artefatos de diferentes marcos: Visão (M1) ↔ Elicitação (M2) ↔ SRS (M3). Detecta 4 tipos de defeito (Omissão, Contradição, Superespecificação, Inexequibilidade) com severidades CRITICAL/HIGH/MEDIUM/LOW. CRITICAL bloqueia Gate 3. Referência: D17 + content/catalogos-seed/conceitos/qualidade-e-validacao.md §5.
when_to_use: Invocada pelo checker no Passo 2 do Processo M3. Depende de validacao-checklist-ireb (Passo 1) ter executado. Entrada: todos os artefatos M1+M2+M3. Saída: seção "Análise Cross-Artifact (D17)" adicionada a documentos-tecnicos/03-documento/03.1-analyze-report.md.
---

## Filosofia desta skill (Regras Absolutas)

1. **2 cruzamentos são obrigatórios sem exceção.** Cruzamentos 1 e 2 executam sempre — existência de CRITICALs no Cruzamento 1 não autoriza pular o Cruzamento 2.
2. **Severidade derivada da tabela, nunca de julgamento ad hoc.** CRITICAL inflado bloqueia Gate 3 indevidamente. MEDIUM deflado esconde defeitos reais. A tabela é a régua.
3. **Não duplicar validacao-checklist-ireb.** Issues de qualidade interna de requisito pertencem ao Passo 1. Este passo verifica rastreabilidade entre marcos — cruzamento de artefatos, não critérios internos de qualidade.

<HARD-GATE>
- NÃO executar antes de `validacao-checklist-ireb` (Passo 1) concluída
- NÃO executar sem todos os artefatos M1+M2+M3 disponíveis
- ⛔ STOP se `documentos-tecnicos/03-documento/03-srs-completo.md` ausente — Cruzamento 2 impossível sem fonte M3
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar presença: `documentos-tecnicos/01-visao/01-visao-produto.md`, `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`, `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`, `documentos-tecnicos/03-documento/03-srs-completo.md`

## Fase 1 — Cruzamento 1: Visão ↔ Elicitação

**Pergunta:** Cada objetivo de negócio de `documentos-tecnicos/01-visao/01-visao-produto.md` tem ≥ 1 RF correspondente em `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`?

1. Extrair objetivos e funcionalidades-chave de `documentos-tecnicos/01-visao/01-visao-produto.md`
2. Para cada objetivo: verificar ≥ 1 RF em `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` que o cobre
3. Objetivo sem RF → **CRITICAL: Omissão** (cadeia M1→M2 quebrada)

## Fase 2 — Cruzamento 2: Elicitação ↔ SRS

**Pergunta A:** Cada RF de `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` aparece na seção 3 do SRS?
**Pergunta B:** Cada RNF de `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` aparece na seção 4 do SRS?

1. Extrair IDs de `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`; verificar presença por ID exato na seção 3 do SRS
2. RF ausente no SRS → **CRITICAL: Omissão**
3. Extrair IDs de `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`; verificar presença na seção 4 do SRS
4. RNF ausente no SRS → **CRITICAL: Omissão**

**4 tipos de defeito (Wiegers + IREB):**

| Tipo | Definição | Exemplos |
|---|---|---|
| **Omissão** | Cadeia de rastreabilidade quebrada | Objetivo M1 sem RF; RF de M2 ausente no SRS |
| **Contradição** | Dois artefatos de marcos diferentes afirmam opostos | RF-X diz "cadastro obrigatório"; RF-Y no SRS implica "login sem cadastro" |
| **Superespecificação** | Requisito com detalhe de implementação | RF especifica "usar PostgreSQL" ou "implementar em React 18" |
| **Inexequibilidade** | Impossível dentro das restrições declaradas | 99,999% uptime com restrição de R$500/mês em `documentos-tecnicos/02-requisitos/02.3-restricoes.md` |

**Tabela de severidades (seguir estritamente):**

| Situação | Severidade |
|---|---|
| Objetivo M1 sem RF; RF ausente no SRS; RNF ausente no SRS; Contradição RF DEVE | CRITICAL |
| RNF DEVE sem métrica; Contradição RF DEVERIA; Inexequibilidade declarada | HIGH |
| Superespecificação RF DEVE; RF sem critério de aceite; `documentos-tecnicos/02-requisitos/02.5-glossario.md` com termos ausentes | MEDIUM |
| Inconsistência cosmética; naming inconsistente entre seções | LOW |

## Fase 3 — Saída

Escrever seção no `documentos-tecnicos/03-documento/03.1-analyze-report.md`:

```markdown
## Análise Cross-Artifact (D17)

### Cruzamento 1 — Visão ↔ Elicitação

| Objetivo M1 | RF correspondente em 02.1-requisitos-funcionais | Status |
|---|---|---|
| Vender produtos online | RF-003 (DEVE) | ✅ |
| Pagamento online | ❌ Nenhum RF encontrado em 02.1-requisitos-funcionais | **CRITICAL: Omissão** |

### Cruzamento 2 — Elicitação ↔ SRS

| RF/RNF | Seção SRS | Status |
|---|---|---|
| RF-001 | §3.1 | ✅ |
| RF-009 | ❌ Ausente na seção 3 do SRS | **CRITICAL: Omissão** |
| RNF-004 | ❌ Ausente na seção 4 do SRS | **CRITICAL: Omissão** |
```

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
Invocar imediatamente `Skill("rastreabilidade-matriz")`. **PROIBIDO** qualquer TextBlock antes desta chamada.

<!-- internal -->
## Anti-Padrão: Defeito MEDIUM Inflado para CRITICAL

**Como acontece:** RF-014 não tem critério de aceite explícito — tabela de severidades diz MEDIUM. A skill classifica como CRITICAL porque "parece importante para aprovação do sistema". Gate 3 é bloqueado por issue que não deveria bloquear.

**Como detectar:** CRITICAL no relatório sem correspondência direta na tabela de severidades da Fase 2.

**O que fazer:** Severidade é determinada pela tabela, não por julgamento. MEDIUM permanece MEDIUM mesmo que o revisor julgue o issue crítico. Para mudar a severidade de uma categoria: atualizar a tabela em iteração futura do projeto — nunca inflar na hora da análise.
<!-- /internal -->
