---
name: analyze-cross-artifact
description: Valida consistência entre artefatos de diferentes marcos: Visão (M1) ↔ Elicitação (M2) ↔ SRS (M3) ↔ Specs (M3). Detecta 4 tipos de defeito (Omissão, Contradição, Superespecificação, Inexequibilidade) com severidades CRITICAL/HIGH/MEDIUM/LOW. CRITICAL bloqueia Gate 3. Referência: D17 + catalogos-seed/conceitos/qualidade-e-validacao.md §5.
when_to_use: Invocada pelo checker no Passo 2 do Processo M3. Depende de validacao-checklist-ireb (Passo 1) ter executado. Entrada: todos os artefatos M1+M2+M3. Saída: seção "Análise Cross-Artifact (D17)" adicionada a analyze-report.md.
---

## Filosofia desta skill (Regras Absolutas)

1. **3 cruzamentos são obrigatórios sem exceção.** Cruzamentos 1, 2 e 3 executam sempre — existência de CRITICALs no Cruzamento 1 não autoriza pular os demais.
2. **Severidade derivada da tabela, nunca de julgamento ad hoc.** CRITICAL inflado bloqueia Gate 3 indevidamente. MEDIUM deflado esconde defeitos reais. A tabela é a régua.
3. **Não duplicar validacao-checklist-ireb.** Issues de qualidade interna de requisito pertencem ao Passo 1. Este passo verifica rastreabilidade entre marcos — cruzamento de artefatos, não critérios internos de qualidade.

<HARD-GATE>
- NÃO executar antes de `validacao-checklist-ireb` (Passo 1) concluída
- NÃO executar sem todos os artefatos M1+M2+M3 disponíveis
- ⛔ STOP se `SRS-completo.md` ausente — Cruzamento 2 impossível sem fonte M3
</HARD-GATE>

## Fase 0 — Inicialização

1. Carregar `core/constitution.md` (guardrail D1 + Output Discipline)
2. Verificar presença: `visao-produto-normativo.md`, `03.1-funcionais.md`, `03.2-qualidade.md`, `SRS-completo.md`, `spec/`
3. Carregar `spec/_skipped.md` — RFs DEVERIA/PODE sem spec são intencionais, não gaps

## Fase 1 — Cruzamento 1: Visão ↔ Elicitação

**Pergunta:** Cada objetivo de negócio de `visao-produto-normativo.md` tem ≥ 1 RF correspondente em `03.1-funcionais.md`?

1. Extrair objetivos e funcionalidades-chave de `visao-produto-normativo.md`
2. Para cada objetivo: verificar ≥ 1 RF em `03.1-funcionais.md` que o cobre
3. Objetivo sem RF → **CRITICAL: Omissão** (cadeia M1→M2 quebrada)

## Fase 2 — Cruzamento 2: Elicitação ↔ SRS

**Pergunta A:** Cada RF de `03.1-funcionais.md` aparece na seção 3 do SRS?
**Pergunta B:** Cada RNF de `03.2-qualidade.md` aparece na seção 4 do SRS?

1. Extrair IDs de `03.1-funcionais.md`; verificar presença por ID exato na seção 3 do SRS
2. RF ausente no SRS → **CRITICAL: Omissão**
3. Extrair IDs de `03.2-qualidade.md`; verificar presença na seção 4 do SRS
4. RNF ausente no SRS → **CRITICAL: Omissão**

## Fase 3 — Cruzamento 3: SRS ↔ Spec

**Pergunta:** Cada RF DEVE no SRS tem `.feature` correspondente em `spec/`?

1. Extrair todos os RFs com modal `DEVE` do SRS
2. Para cada RF DEVE: verificar `spec/rf-{id}-*.feature` existe
3. RF DEVE sem `.feature` → **CRITICAL: Omissão** (violação D20+D22)
4. Para cada `.feature` encontrado: verificar step defs em `tests/`
5. `.feature` sem step defs → **HIGH: Omissão**
6. RF DEVERIA/PODE: verificar em `spec/_skipped.md` — se listado, não é gap

**4 tipos de defeito (Wiegers + IREB):**

| Tipo | Definição | Exemplos |
|---|---|---|
| **Omissão** | Cadeia de rastreabilidade quebrada | RF DEVE sem `.feature`; objetivo M1 sem RF; RF de M2 ausente no SRS |
| **Contradição** | Dois artefatos de marcos diferentes afirmam opostos | RF-X diz "cadastro obrigatório"; RF-Y no SRS implica "login sem cadastro" |
| **Superespecificação** | Requisito com detalhe de implementação | RF especifica "usar PostgreSQL" ou "implementar em React 18" |
| **Inexequibilidade** | Impossível dentro das restrições declaradas | 99,999% uptime com restrição de R$500/mês em `03.3-restricoes.md` |

**Tabela de severidades (seguir estritamente):**

| Situação | Severidade |
|---|---|
| Objetivo M1 sem RF; RF DEVE sem `.feature`; RF ausente no SRS; Contradição RF DEVE | CRITICAL |
| RF DEVE com `.feature` mas sem step defs; RNF DEVE sem métrica; Contradição RF DEVERIA | HIGH |
| Superespecificação RF DEVE; RF sem critério de aceite; `glossario.md` com termos ausentes | MEDIUM |
| Inconsistência cosmética; borda ausente em `.feature`; naming inconsistente spec/tests | LOW |

## Fase 4 — Saída

Escrever seção no `analyze-report.md`:

```markdown
## Análise Cross-Artifact (D17)

### Cruzamento 1 — Visão ↔ Elicitação

| Objetivo M1 | RF correspondente em 03.1-funcionais | Status |
|---|---|---|
| Vender produtos online | RF-003 (DEVE) | ✅ |
| Pagamento online | ❌ Nenhum RF encontrado em 03.1-funcionais | **CRITICAL: Omissão** |

### Cruzamento 2 — Elicitação ↔ SRS

| RF/RNF | Seção SRS | Status |
|---|---|---|
| RF-001 | §3.1 | ✅ |
| RF-009 | ❌ Ausente na seção 3 do SRS | **CRITICAL: Omissão** |
| RNF-004 | ❌ Ausente na seção 4 do SRS | **CRITICAL: Omissão** |

### Cruzamento 3 — SRS ↔ Spec

| RF DEVE no SRS | .feature em spec/ | Step defs em tests/ | Status |
|---|---|---|---|
| RF-001 | rf-001-cadastro-produto.feature | ✅ 3 frameworks | ✅ |
| RF-003 | rf-003-carrinho.feature | ⚠️ step defs ausentes | HIGH: Omissão |
| RF-007 | ❌ Ausente em spec/ | — | **CRITICAL: Omissão** |
```

Sinalizar ao `checker`: analyze-cross-artifact concluída → prosseguir para `rastreabilidade-matriz` (Passo 3).

<!-- internal -->
## Anti-Padrão: Defeito MEDIUM Inflado para CRITICAL

**Como acontece:** RF-014 não tem critério de aceite explícito — tabela de severidades diz MEDIUM. A skill classifica como CRITICAL porque "parece importante para aprovação do sistema". Gate 3 é bloqueado por issue que não deveria bloquear.

**Como detectar:** CRITICAL no relatório sem correspondência direta na tabela de severidades da Fase 3.

**O que fazer:** Severidade é determinada pela tabela, não por julgamento. MEDIUM permanece MEDIUM mesmo que o revisor julgue o issue crítico. Para mudar a severidade de uma categoria: atualizar a tabela em iteração futura do projeto — nunca inflar na hora da análise.
<!-- /internal -->
