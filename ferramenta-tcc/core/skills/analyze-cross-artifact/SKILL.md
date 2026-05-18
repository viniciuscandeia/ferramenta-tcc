---
name: analyze-cross-artifact
description: Valida consistência entre artefatos de diferentes marcos: Visão (M1) ↔ Elicitação (M2) ↔ SRS (M3) ↔ Specs (M3). Detecta 4 tipos de defeito (Omissão, Contradição, Superespecificação, Inexequibilidade) com severidades CRITICAL/HIGH/MEDIUM/LOW. CRITICAL bloqueia Gate 3. Referência: D17 + catalogos-seed/conceitos/qualidade-e-validacao.md §5.
when_to_use: Invocada pelo checker no Passo 2 do Processo M3. Depende de validacao-checklist-ireb (Passo 1) ter executado. Entrada: todos os artefatos M1+M2+M3. Saída: seção "Análise Cross-Artifact (D17)" adicionada a analyze-report.md.
---

# Skill: analyze-cross-artifact

**Referência:** D17 (análise cross-artifact) + Wiegers *Software Requirements* Ch. 17 + IREB §3.8 (consistência)
**Marco:** M3 — Detalhamento (Fase B, Passo 2)
**Invocada por:** `checker`

---

## 4 TIPOS DE DEFEITO (Wiegers + IREB)

| Tipo | Definição | Exemplos |
|---|---|---|
| **Omissão** | Algo necessário está faltando — a cadeia de rastreabilidade está quebrada | RF DEVE sem `.feature` correspondente; objetivo M1 sem nenhum RF; RF de M2 ausente no SRS |
| **Contradição** | Dois artefatos de marcos diferentes afirmam coisas opostas sobre o mesmo elemento | RF-X em `03.1-funcionais.md` diz "usuário DEVE confirmar e-mail" mas RF-Y no SRS implica "login sem cadastro prévio" |
| **Superespecificação** | Requisito contém detalhes de implementação que deveriam ser decisão do time de desenvolvimento | RF especifica "usar PostgreSQL como banco de dados" ou "implementar em React 18" |
| **Inexequibilidade** | Requisito impossível de satisfazer dentro das restrições declaradas do projeto | RNF exige 99,999% de uptime com restrição de orçamento de R$500/mês declarada em `03.3-restricoes.md` |

---

## REGRAS DE SEVERIDADE

| Situação | Severidade |
|---|---|
| Omissão que quebra cadeia de rastreabilidade (objetivo M1 → RF → SRS → spec) | CRITICAL |
| Contradição entre RF DEVE em artefatos diferentes | CRITICAL |
| RF DEVE no SRS sem `.feature` correspondente em `spec/` (violação D20+D22) | CRITICAL |
| RF DEVE com `.feature` mas step defs ausentes em `tests/` | HIGH |
| RNF DEVE sem métrica que deveria ter (complemento ao IREB §3.8) | HIGH |
| Contradição entre RF DEVERIA em artefatos diferentes | HIGH |
| Superespecificação em RF DEVE (detalhes de implementação) | MEDIUM |
| RF sem critério de aceite explícito | MEDIUM |
| `glossario.md` sem termos presentes no SRS | MEDIUM |
| Inconsistência cosmética de nomenclatura entre artefatos | LOW |
| Cenário de borda ausente em `.feature` | LOW |
| Naming inconsistente entre `spec/` e `tests/` | LOW |

---

## 3 CRUZAMENTOS OBRIGATÓRIOS

### Cruzamento 1 — Visão ↔ Elicitação

**Pergunta:** Cada objetivo de negócio e funcionalidade-chave declarada em `visao-produto-normativo.md` tem ≥ 1 RF correspondente em `03.1-funcionais.md`?

**Processo:**
1. Extrair lista de objetivos de negócio e funcionalidades-chave de `visao-produto-normativo.md` (seção "problema-resolvido" e "funcionalidades-chave")
2. Para cada objetivo: verificar se existe ≥ 1 RF em `03.1-funcionais.md` que o cobre
3. Objetivo sem nenhum RF cobrindo → **CRITICAL: Omissão** (cadeia rastreabilidade quebrada em M1→M2)

### Cruzamento 2 — Elicitação ↔ SRS

**Pergunta A:** Cada RF de `03.1-funcionais.md` aparece na seção 3 do `SRS-completo.md`?
**Pergunta B:** Cada RNF de `03.2-qualidade.md` aparece na seção 4 do `SRS-completo.md`?

**Processo:**
1. Extrair lista de IDs de RF de `03.1-funcionais.md`
2. Verificar presença de cada ID na seção 3 do SRS (busca por ID exato)
3. RF ausente no SRS → **CRITICAL: Omissão**
4. Extrair lista de IDs de RNF de `03.2-qualidade.md`
5. Verificar presença de cada ID na seção 4 do SRS
6. RNF ausente no SRS → **CRITICAL: Omissão**

### Cruzamento 3 — SRS ↔ Spec

**Pergunta:** Cada RF com modal `DEVE` no SRS tem `.feature` correspondente em `spec/`?

**Processo:**
1. Extrair de `SRS-completo.md` todos os RFs com modal `DEVE`
2. Para cada RF DEVE: verificar se existe `spec/rf-{id}-*.feature` em `spec/`
3. RF DEVE sem `.feature` → **CRITICAL: Omissão** (violação D20+D22)
4. Para cada `.feature` encontrado: verificar se step defs existem em `tests/`
5. `.feature` sem step defs correspondentes → **HIGH: Omissão**
6. RF com modal `DEVERIA` ou `PODE`: verificar presença em `spec/_skipped.md` (não é omissão — é esperado)

---

## PROCESSO

### Entrada

- `visao-produto-normativo.md` — objetivos M1 (fonte de verdade para Cruzamento 1)
- `03.1-funcionais.md` — lista de RFs M2 (fonte de verdade para Cruzamentos 1 e 2)
- `03.2-qualidade.md` — lista de RNFs M2 (fonte de verdade para Cruzamento 2)
- `SRS-completo.md` — documento M3 (alvo dos Cruzamentos 2 e 3)
- `spec/*.feature` — especificações Gherkin M3 (alvo do Cruzamento 3)
- `tests/` — step definitions M3 (alvo do Cruzamento 3, parte step defs)
- `spec/_skipped.md` — RFs DEVERIA/PODE intencionalmente sem spec (excluir de Cruzamento 3)

### Execução

1. Realizar Cruzamento 1: listar resultados por objetivo M1
2. Realizar Cruzamento 2: listar resultados por RF e por RNF
3. Realizar Cruzamento 3: listar resultados por RF DEVE
4. Verificar 4 tipos de defeito em todos os cruzamentos simultaneamente
5. Escrever seção completa no `analyze-report.md` sem omitir nenhum issue encontrado

Não parar no primeiro CRITICAL — relatar todos os issues de todos os 3 cruzamentos.

---

## SAÍDA — Seção adicionada ao analyze-report.md

```markdown
## Análise Cross-Artifact (D17)

### Cruzamento 1 — Visão ↔ Elicitação

| Objetivo M1 | RF correspondente em 03.1-funcionais | Status |
|---|---|---|
| Vender produtos online | RF-003 (DEVE) | ✅ |
| Pagamento online | ❌ Nenhum RF encontrado em 03.1-funcionais | **CRITICAL: Omissão** |
| Gestão de estoque | RF-008 (DEVE), RF-009 (DEVERIA) | ✅ |

### Cruzamento 2 — Elicitação ↔ SRS

| RF/RNF | Seção SRS | Status |
|---|---|---|
| RF-001 | SRS §3.1 | ✅ |
| RF-009 | ❌ Ausente na seção 3 do SRS | **CRITICAL: Omissão** |
| RNF-002 | SRS §4.2 | ✅ |
| RNF-004 | ❌ Ausente na seção 4 do SRS | **CRITICAL: Omissão** |

### Cruzamento 3 — SRS ↔ Spec

| RF DEVE no SRS | .feature em spec/ | Step defs em tests/ | Status |
|---|---|---|---|
| RF-001 | spec/rf-001-cadastro-produto.feature | ✅ 3 frameworks | ✅ |
| RF-003 | spec/rf-003-carrinho.feature | ⚠️ step defs ausentes | HIGH: Omissão |
| RF-007 | ❌ Ausente em spec/ | — | **CRITICAL: Omissão** |
```

---

## REGRAS DE QUALIDADE

- Sem interação com usuário — análise automática
- Os 3 cruzamentos são obrigatórios — nunca pular um cruzamento mesmo que o anterior já tenha CRITICALs
- Relatar todos os issues encontrados (não parar no primeiro CRITICAL)
- Usar IDs exatamente como aparecem nos artefatos-fonte (preservar maiúsculas, hífens, numeração)
- RFs com modal `DEVERIA` ou `PODE` sem `.feature` não são issues — verificar `spec/_skipped.md`
- RNFs e Restrições não têm spec por design — ausência de `.feature` para RNF não é omissão
- Issues já cobertos por `validacao-checklist-ireb` (Passo 1): não duplicar; referenciar "ver IREB §3.8 acima"
