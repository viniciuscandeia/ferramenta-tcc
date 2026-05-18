---
name: rastreabilidade-matriz
description: Gera rastreabilidade.md com matriz bidirecional ligando Objetivo de negócio (M1) → RF/RNF (M2) → Seção SRS (M3) → Spec (.feature) → Step definitions → Stakeholder origem. Detecta lacunas (células vazias = candidatos a issues para analyze-cross-artifact). Referência: catalogos-seed/conceitos/qualidade-e-validacao.md §4 (rastreabilidade bidirecional forward+backward).
when_to_use: Invocada pelo checker no Passo 3 do Processo M3. Entrada: visao-produto-normativo.md + 03.1-funcionais.md + 03.2-qualidade.md + SRS-completo.md + spec/*.feature. Saída: rastreabilidade.md.
---

# Skill: rastreabilidade-matriz

**Referência:** IREB §3.8 (rastreabilidade) + catalogos-seed/conceitos/qualidade-e-validacao.md §4
**Marco:** M3 — Detalhamento (Fase B, Passo 3)
**Invocada por:** `checker`

---

## CONCEITO DE RASTREABILIDADE BIDIRECIONAL

**Forward tracing (M1 → test):** A partir de um objetivo de negócio, consigo chegar até o teste que valida sua implementação?
- Objetivo M1 → RF → Seção SRS → `.feature` → Step def

**Backward tracing (test → M1):** A partir de um teste ou spec, consigo rastrear de volta até a necessidade de negócio que o originou?
- Step def → `.feature` → RF → Objetivo M1 → Stakeholder

Lacunas em qualquer elo desta cadeia são candidatos a issues de Omissão para `analyze-cross-artifact`.

---

## COLUNAS DA MATRIZ

| Objetivo M1 | RF/RNF ID | Modal | Seção SRS | Spec (.feature) | Test (step def) | Stakeholder origem |
|---|---|---|---|---|---|---|

**Regras por coluna:**

- **Objetivo M1:** extraído de `visao-produto-normativo.md` (funcionalidades-chave + problema-resolvido); usar texto curto descritivo
- **RF/RNF ID:** ID exato como aparece nos artefatos M2 (ex.: RF-001, RNF-002, REST-001)
- **Modal:** `DEVE` / `DEVERIA` / `PODE` / `—` (para restrições sem modal)
- **Seção SRS:** referência de seção no SRS (ex.: §3.1, §4.2, §5.1); "—" se ausente (gap)
- **Spec (.feature):** nome do arquivo em `spec/` (ex.: `rf-001-cadastro.feature`); "—" para RNFs/Restrições (por design, não gap); "❌" para RF DEVE sem spec (gap CRITICAL)
- **Test (step def):** `✅` se step defs existem em `tests/`; nome da estratégia para RNFs (ex.: `strategy: OWASP ZAP`); "—" para restrições; "❌" se `.feature` existe mas step defs ausentes (gap HIGH)
- **Stakeholder origem:** perfil de stakeholder de M1 que originou a necessidade (ex.: Artesão, Comprador, Todos)

---

## PROCESSO

### Passo 1 — Extrair objetivos de M1

- Ler `visao-produto-normativo.md`
- Identificar: funcionalidades-chave declaradas + problema-resolvido + perfis de stakeholder
- Criar lista numerada de objetivos de negócio (texto curto, máx. 5 palavras)

### Passo 2 — Mapear objetivos → RF/RNF

- Para cada objetivo de M1: localizar em `03.1-funcionais.md` os RFs que o cobrem (≥ 1 por objetivo)
- Para RNFs de `03.2-qualidade.md`: associar ao objetivo de negócio mais próximo (ex.: RNF de performance → objetivo de experiência do usuário)
- Para restrições de `03.3-restricoes.md` (se disponível): associar ao objetivo ou stakeholder mais relacionado

### Passo 3 — Mapear RF/RNF → SRS

- Para cada RF/RNF: localizar a seção correspondente no `SRS-completo.md`
- Registrar seção exata (§3.X para RFs, §4.X para RNFs, §5.X para restrições)
- RF/RNF não encontrado no SRS: registrar "❌ ausente" na coluna Seção SRS

### Passo 4 — Mapear RF → Spec

- Para cada RF com modal `DEVE`: localizar `.feature` correspondente em `spec/`
- Convenção de nomenclatura: `spec/rf-{id-lowercase}-{descricao-curta}.feature`
- RF DEVE sem `.feature`: registrar "❌" na coluna Spec
- RF DEVERIA / PODE: verificar `spec/_skipped.md`; se listado, registrar "— (skipped)" na coluna Spec
- RNFs e Restrições: registrar "—" na coluna Spec (ausência intencional por design)

### Passo 5 — Mapear Spec → Step defs

- Para cada `.feature` encontrado no Passo 4: verificar existência de step defs em `tests/`
- Step defs presentes: registrar `✅`
- `.feature` sem step defs: registrar "❌"
- Para RNFs com estratégia em `TESTING-STRATEGY.md`: registrar `strategy: [ferramenta]` (ex.: `strategy: OWASP ZAP`, `strategy: k6`)

### Passo 6 — Preencher stakeholder origem

- Para cada RF/RNF: identificar qual perfil de stakeholder de M1 originou a necessidade
- Usar os nomes de perfil exatamente como definidos em `visao-produto-normativo.md`
- Se múltiplos stakeholders: listar separados por vírgula ou usar "Todos"

### Passo 7 — Gerar rastreabilidade.md

- Montar a matriz completa com todas as linhas
- Adicionar seção de resumo com contagens de gaps

---

## SAÍDA — rastreabilidade.md

```markdown
# Matriz de Rastreabilidade

> Gerado automaticamente pelo checker em M3 Passo 3.
> Forward tracing: Objetivo M1 → RF/RNF → SRS → Spec → Test
> Backward tracing: qualquer linha com "❌" indica gap na cadeia de rastreabilidade.

| Objetivo M1 | RF/RNF | Modal | Seção SRS | Spec | Test | Stakeholder |
|---|---|---|---|---|---|---|
| Vender produtos online | RF-001 | DEVE | §3.1 | rf-001-cadastro-produto.feature | ✅ | Artesão |
| Vender produtos online | RF-003 | DEVE | §3.3 | rf-003-carrinho.feature | ✅ | Artesão, Comprador |
| Pagamento online | RF-005 | DEVE | §3.5 | rf-005-pagamento.feature | ❌ | Comprador |
| Gestão de estoque | RF-008 | DEVE | §3.8 | rf-008-estoque.feature | ✅ | Artesão |
| Gestão de estoque | RF-009 | DEVERIA | §3.9 | — (skipped) | — | Artesão |
| Segurança de dados | RNF-002 | DEVE | §4.2 | — (RNF, sem spec) | strategy: OWASP ZAP | Todos |
| Desempenho | RNF-003 | DEVE | §4.3 | — (RNF, sem spec) | strategy: k6 | Todos |
| [objetivo sem RF] | ❌ Nenhum RF encontrado | — | — | — | — | — |
| Compatibilidade mobile | REST-001 | — | §5.1 | — (restrição) | — | Artesão |

---

## Resumo de Gaps

| Tipo de gap | Quantidade | Severidade potencial |
|---|---|---|
| Objetivo M1 sem RF | 1 | CRITICAL (Omissão) |
| RF sem seção no SRS | 0 | — |
| RF DEVE sem .feature | 0 | — |
| .feature sem step defs | 1 | HIGH (Omissão) |
| RNF sem estratégia de teste | 0 | — |
```

---

## REGRAS DE QUALIDADE

- Gerar a matriz mesmo que haja células vazias — célula "❌" é mais informativa do que não existir a linha
- Usar "—" para ausências esperadas por design (RNFs, Restrições, RF DEVERIA/PODE em _skipped.md)
- Usar "❌" para ausências que indicam gap real (RF DEVE sem spec, .feature sem step defs, RF sem SRS)
- Sem interação com usuário — geração automática
- Preservar IDs exatamente como nos artefatos-fonte
- Restrições (`REST-`) têm "—" em Spec e Test por design — não registrar como gap
- A seção de Resumo de Gaps é obrigatória — alimenta a decisão do checker sobre issues adicionais
- Este artefato é informativo para Gate 3 — gaps aqui que ainda não foram reportados em analyze-cross-artifact devem ser considerados pelo checker para consolidação final
