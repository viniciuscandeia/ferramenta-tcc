---
name: rastreabilidade-matriz
marco: [M3]
description: Gera rastreabilidade.md com matriz bidirecional ligando Objetivo de negócio (M1) → RF/RNF (M2) → Seção SRS (M3) → Spec (.feature) → Step definitions → Stakeholder origem. Detecta lacunas (células vazias = candidatos a issues para analyze-cross-artifact). Referência: content/catalogos-seed/conceitos/qualidade-e-validacao.md §4 (rastreabilidade bidirecional forward+backward).
when_to_use: Invocada pelo checker no Passo 3 do Processo M3. Entrada: documentos-tecnicos/01-visao/01-visao-produto.md + documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md + documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md + documentos-tecnicos/03-documento/03-srs-completo.md + documentos-tecnicos/03-documento/04-spec/*.feature. Saída: documentos-tecnicos/03-documento/03.2-rastreabilidade.md.
---

## Filosofia desta skill (Regras Absolutas)

1. **"—" vs "❌" é o controle de qualidade central.** "—" = ausência intencional por design (RNF sem spec, RF DEVERIA em `_skipped.md`). "❌" = gap real. Confundir os dois mascara gaps ou gera alarmes falsos para o checker.
2. **Gerar a matriz mesmo incompleta.** Célula "❌" é mais informativa que linha ausente. Omitir linha = silenciar gap = pior resultado que registrar o problema explicitamente.
3. **Resumo de Gaps é obrigatório** — alimenta o checker para consolidação final e decisão de Gate 3.

<HARD-GATE>
- NÃO executar antes de `validacao-checklist-ireb` e `analyze-cross-artifact` concluídas
- NÃO executar sem `documentos-tecnicos/01-visao/01-visao-produto.md` (Fases 1 e 6 impossíveis sem ela)
- ⛔ STOP se `documentos-tecnicos/03-documento/04-spec/` não existe — Fases 4 e 5 dependem de spec/
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar artefatos obrigatórios: `documentos-tecnicos/01-visao/01-visao-produto.md`, `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`, `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`, `documentos-tecnicos/03-documento/03-srs-completo.md`, `documentos-tecnicos/03-documento/04-spec/`
3. Carregar `documentos-tecnicos/03-documento/04-spec/_skipped.md` — lista de RFs DEVERIA/PODE sem spec (ausência intencional, não gap)

## Fase 1 — Extrair Objetivos de M1

- Ler `documentos-tecnicos/01-visao/01-visao-produto.md`: funcionalidades-chave + problema-resolvido + perfis de stakeholder
- Criar lista numerada de objetivos de negócio (texto curto, máx. 5 palavras por objetivo)

## Fase 2 — Mapear Objetivos → RF/RNF

- Para cada objetivo M1: localizar RFs cobrindo em `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` (≥ 1 por objetivo esperado)
- Para RNFs de `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`: associar ao objetivo de negócio mais próximo
- Para restrições de `documentos-tecnicos/02-requisitos/02.3-restricoes.md` (se disponível): associar ao objetivo ou stakeholder mais relacionado

## Fase 3 — Mapear RF/RNF → SRS

- Para cada RF/RNF: localizar seção em `documentos-tecnicos/03-documento/03-srs-completo.md`
- Registrar seção exata (§3.X para RFs, §4.X para RNFs, §5.X para restrições)
- RF/RNF não encontrado no SRS: registrar "❌ ausente" na coluna Seção SRS

## Fase 4 — Mapear RF → Spec e Spec → Step Defs

**RF → Spec:**
- RF DEVE: verificar `documentos-tecnicos/03-documento/04-spec/rf-{id-lowercase}-*.feature` em `documentos-tecnicos/03-documento/04-spec/`; ausente → "❌"
- RF DEVERIA/PODE: verificar em `documentos-tecnicos/03-documento/04-spec/_skipped.md`; se listado → "— (skipped)"; se não listado → "❌"
- RNFs e Restrições: "—" por design (ausência intencional, não gap)

**Spec → Step defs:**
- Para cada `.feature` encontrado: verificar step defs em `documentos-tecnicos/03-documento/05-tests/unit/` e `documentos-tecnicos/03-documento/05-tests/acceptance/`
- Presentes (3 frameworks) → "✅"; `.feature` sem step defs → "❌"
- Para RNFs com estratégia em `documentos-tecnicos/03-documento/06-estrategia-testes.md`: registrar `strategy: [ferramenta]`

## Fase 5 — Preencher Stakeholder Origem

- Para cada RF/RNF: identificar perfil de stakeholder de `documentos-tecnicos/01-visao/01-visao-produto.md` que originou a necessidade
- Usar nomes exatamente como definidos no documento (não parafrasear)
- Múltiplos stakeholders: listar separados por vírgula ou usar "Todos"

## Fase 6 — Saída

Salvar como `documentos-tecnicos/03-documento/03.2-rastreabilidade.md`:

```markdown
# Matriz de Rastreabilidade

> Gerado automaticamente pelo checker em M3 Passo 3.
> Forward tracing: Objetivo M1 → RF/RNF → SRS → Spec → Test
> Backward tracing: qualquer "❌" indica gap na cadeia de rastreabilidade.

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

Sinalizar ao `checker`: rastreabilidade-matriz concluída → gaps não reportados em `analyze-cross-artifact` devem ser considerados para consolidação final antes de Gate 3.

<!-- internal -->
## Anti-Padrão: RF DEVERIA/PODE Marcado como Gap

**Como acontece:** RF-009 com modal DEVERIA não tem `.feature` → coluna Spec marcada "❌" → reportado como gap de Omissão → checker escala para CRITICAL desnecessariamente, bloqueando Gate 3 por issue esperado por design.

**Como detectar:** "❌" em Spec para RF com modal DEVERIA ou PODE — verificar se consta em `documentos-tecnicos/03-documento/04-spec/_skipped.md`.

**O que fazer:** RF DEVERIA/PODE listado em `documentos-tecnicos/03-documento/04-spec/_skipped.md` → registrar "— (skipped)", não "❌". RF DEVERIA/PODE **não** listado em `documentos-tecnicos/03-documento/04-spec/_skipped.md` → registrar "❌" e reportar como issue de processo (por que não foi para _skipped.md?).
<!-- /internal -->
