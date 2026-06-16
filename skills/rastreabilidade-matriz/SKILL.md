---
name: rastreabilidade-matriz
disallowed-tools: [WebFetch, WebSearch, NotebookEdit]
marco: [M3]
description: Gera rastreabilidade.md com matriz bidirecional ligando Objetivo de negócio (M1) → RF/RNF (M2) → Seção SRS (M3) → Stakeholder origem. Detecta lacunas (células vazias = candidatos a issues para analyze-cross-artifact). Referência: content/catalogos-seed/conceitos/qualidade-e-validacao.md §4 (rastreabilidade bidirecional forward+backward).
when_to_use: Invocada pelo checker no Passo 3 do Processo M3. Entrada: documentos-tecnicos/01-visao/01-visao-produto.md + documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md + documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md + documentos-tecnicos/03-documento/03-srs-completo.md. Saída: documentos-tecnicos/03-documento/03.2-rastreabilidade.md.
---

## Filosofia desta skill (Regras Absolutas)

1. **"—" vs "❌" é o controle de qualidade central.** "—" = ausência intencional por design (ex.: restrição sem prioridade de requisito). "❌" = gap real. Confundir os dois mascara gaps ou gera alarmes falsos para o checker.
2. **Gerar a matriz mesmo incompleta.** Célula "❌" é mais informativa que linha ausente. Omitir linha = silenciar gap = pior resultado que registrar o problema explicitamente.
3. **Resumo de Gaps é obrigatório** — alimenta o checker para consolidação final e decisão de Gate 3.

<HARD-GATE>
- NÃO executar antes de `validacao-checklist-ireb` e `analyze-cross-artifact` concluídas
- NÃO executar sem `documentos-tecnicos/01-visao/01-visao-produto.md` (Fases 1 e 4 impossíveis sem ela)
- ⛔ STOP se `documentos-tecnicos/03-documento/03-srs-completo.md` não existe — Fase 3 depende dele
</HARD-GATE>

## Fase 0 — Inicialização

1. _(Constitution injetada no contexto do agente invocador — D15. Não ler em runtime.)_
2. Verificar artefatos obrigatórios: `documentos-tecnicos/01-visao/01-visao-produto.md`, `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md`, `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`, `documentos-tecnicos/03-documento/03-srs-completo.md`

## Fase 1 — Extrair Objetivos de M1

- Ler `documentos-tecnicos/01-visao/01-visao-produto.md`: funcionalidades-chave + problema-resolvido + perfis de stakeholder
- Criar lista de objetivos de negócio com identificadores sequenciais (`OBJ-001`, `OBJ-002`, …):
  - Texto curto, máx. 5 palavras por objetivo
  - Formato: `OBJ-NNN — [descrição curta]`
  - Os IDs são usados nas demais colunas da matriz e no SRS §6

## Fase 2 — Mapear Objetivos → RF/RNF

- Para cada objetivo M1: localizar RFs cobrindo em `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` (≥ 1 por objetivo esperado)
- Para RNFs de `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`: associar ao objetivo de negócio mais próximo
- Para restrições de `documentos-tecnicos/02-requisitos/02.3-restricoes.md` (se disponível): associar ao objetivo ou stakeholder mais relacionado

## Fase 3 — Mapear RF/RNF → SRS

- Para cada RF/RNF: localizar seção em `documentos-tecnicos/03-documento/03-srs-completo.md`
- Registrar seção exata (§3.X para RFs, §4.X para RNFs, §5.X para restrições)
- RF/RNF não encontrado no SRS: registrar "❌ ausente" na coluna Seção SRS

## Fase 4 — Preencher Stakeholder Origem

- Para cada RF/RNF: identificar perfil de stakeholder de `documentos-tecnicos/01-visao/01-visao-produto.md` que originou a necessidade
- Usar nomes exatamente como definidos no documento (não parafrasear)
- Múltiplos stakeholders: listar separados por vírgula ou usar "Todos"

## Fase 5 — Saída

Salvar como `documentos-tecnicos/03-documento/03.2-rastreabilidade.md`:

```markdown
# Apêndice A — Matriz de Rastreabilidade (completa)

> Gerado automaticamente pelo checker em M3 Passo 3.
> Forward tracing: Objetivo M1 → RF/RNF → Seção SRS → Stakeholder.
> Backward tracing: qualquer "❌" indica gap na cadeia de rastreabilidade.

| Objetivo M1 | RF/RNF | Prioridade | Seção SRS | Stakeholder |
|---|---|---|---|---|
| OBJ-001 — Vender produtos online | RF-001 | Essencial | §3.1 | Artesão |
| OBJ-001 — Vender produtos online | RF-003 | Essencial | §3.3 | Artesão, Comprador |
| OBJ-002 — Pagamento online | RF-005 | Essencial | §3.5 | Comprador |
| OBJ-003 — Gestão de estoque | RF-008 | Essencial | §3.8 | Artesão |
| OBJ-003 — Gestão de estoque | RF-009 | Importante | §3.9 | Artesão |
| OBJ-004 — Segurança de dados | RNF-002 | Essencial | §4.2 | Todos |
| OBJ-004 — Segurança de dados | RNF-003 | Essencial | §4.3 | Todos |
| OBJ-005 — [objetivo sem RF] | ❌ Nenhum RF encontrado | — | — | — |
| OBJ-001 — Vender produtos online | REST-001 | — | §5.1 | Artesão |

---

## Resumo de Gaps

| Tipo de gap | Quantidade | Severidade potencial |
|---|---|---|
| Objetivo M1 sem RF | 1 | CRITICAL (Omissão) |
| RF sem seção no SRS | 0 | — |
| RNF sem seção no SRS | 0 | — |
| RF/RNF sem stakeholder origem | 0 | — |
```

⚡ **AÇÃO OBRIGATÓRIA — SEM TEXTO INTERMEDIÁRIO:**
Orquestrador deve agir imediatamente: executar PRE-FLIGHT do Gate 3 e abrir gate via `AskUserQuestion`.
Gaps não reportados em `analyze-cross-artifact` devem ser considerados na consolidação final.
**PROIBIDO** qualquer TextBlock antes desta ação.

<!-- internal -->
## Anti-Padrão: Ausência Intencional Marcada como Gap

**Como acontece:** REST-001 (restrição) não é um requisito priorizável → coluna Prioridade marcada "❌" → reportado como gap → checker escala desnecessariamente, poluindo o relatório com falso positivo.

**Como detectar:** "❌" em coluna que, para aquele tipo de item, é ausência por design (restrições não têm prioridade de requisito; premissas não têm seção de requisito).

**O que fazer:** Ausência por design → registrar "—", não "❌". "❌" é reservado para quebra real da cadeia: objetivo sem RF, RF/RNF sem seção no SRS, item sem stakeholder identificável.
<!-- /internal -->
