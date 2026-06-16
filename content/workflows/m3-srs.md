# Workflow M3 — Detalhamento

**Sub-agentes responsáveis:** `documenter` (Fase A) → `checker` (Fase B, loop de validação)
**Entrada:** artefatos M1 aprovados (Gate 1) + artefatos M2 aprovados (Gate 2)
**Saída:** `documentos-tecnicos/03-documento/03-srs-completo.md` + `documentos-para-leigo/03-documento/03-documento-do-projeto.md` + `documentos-tecnicos/03-documento/03.3-diagramas.md` + `documentos-tecnicos/03-documento/03.1-analyze-report.md` + `documentos-tecnicos/03-documento/03.2-rastreabilidade.md`
**Gate de saída:** Gate 3 — usuário aprova `documentos-para-leigo/03-documento/03-documento-do-projeto.md`; `documentos-tecnicos/03-documento/03.1-analyze-report.md` sem issues CRITICAL

---

## SEQUÊNCIA DE EXECUÇÃO

```
ENTRADA (artefatos M1+M2 aprovados)
  │
  ▼
╔══════════════════════════════════╗
║  FASE A — Geração de Artefatos   ║  sub-agente: documenter
╠══════════════════════════════════╣
║ [A1] requisito-ears              ║  → formata RFs+RNFs com EARS + RFC 2119
║ [A2] modelagem-visual            ║  → 03.3-diagramas.md (contexto, caso de uso, ER)
║ [A3] srs-ireb-montagem           ║  → SRS com 8 seções IREB §3.3.3 (diagramas embutidos)
║ [A4] traducao-gate               ║  → 03-documento-do-projeto.md (versão leigo)
╚═════════════════╤════════════════╝
                  │ 03-srs-completo.md + 03.3-diagramas.md
                  ▼
╔══════════════════════════════════╗
║  FASE B — Validação + Loop       ║  sub-agente: checker
╠══════════════════════════════════╣
║ [B1] validacao-checklist-ireb    ║  → 6+6 critérios IREB §3.8
║ [B2] analyze-cross-artifact      ║  → Visão↔Elicitação↔SRS (D17)
║ [B3] rastreabilidade-matriz      ║  → 03.2-rastreabilidade.md (Objetivo→RF→SRS→Stakeholder)
╚═════════════════╤════════════════╝
                  │
          CRITICAL issues?
         /              \
       SIM              NÃO
        │                │
   (volta ao         [B4] consolidar
    documenter        analyze-report.md
    modo correção)    → sem CRITICAL
   iteração N+1              │
   (dinâmico)         [GATE 3]
                    SIM → M4 (opcional) ou encerrar
                    NÃO → volta ao documenter com feedback do usuário
```

---

## DETALHES DE CADA PASSO

### FASE A — Sub-agente: documenter

#### [A1] requisito-ears

- Invocar skill 'requisito-ears'
- Input: `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` + `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` (artefatos M2 aprovados)
- Output: versões formatadas de cada RF e RNF no padrão EARS (Event-driven, Ubiquitous, State-driven, Optional, Unwanted behaviour) com modal RFC 2119 (`DEVE` / `DEVERIA` / `PODE`)
- Sem interação com usuário — transformação de formato pura

#### [A2] modelagem-visual

- Invocar skill 'modelagem-visual'
- Input: `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` + `documentos-tecnicos/02-requisitos/02.5-glossario.md`
- Output: `documentos-tecnicos/03-documento/03.3-diagramas.md` com 3 diagramas Mermaid (Contexto, Caso de Uso, ER) + subconjunto leigo-safe (`<!-- LEIGO-SAFE-START/END -->`)
- Se falhar: registrar em `_pendencias.md` e prosseguir (diagramas são condicionais — não bloqueiam gate)
- Sem interação com usuário

#### [A3] srs-ireb-montagem

- Invocar skill 'srs-ireb-montagem'
- Input: RFs+RNFs formatados de [A1] + `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-tecnicos/02-requisitos/02.5-glossario.md` + `documentos-tecnicos/03-documento/03.3-diagramas.md` (de [A2])
- Output: `documentos-tecnicos/03-documento/03-srs-completo.md` com 8 seções IREB §3.3.3:
  1. Introdução (escopo, referências)
  2. Visão geral do sistema (diagramas de contexto em §2.1 e de estrutura de dados em §2.2 embutidos)
  3. Requisitos funcionais (RFs em EARS + RFC 2119; um diagrama de caso de uso por módulo, gerado na montagem)
  4. Requisitos de qualidade (RNFs com métricas)
  5. Interfaces externas (APIs, sistemas legados, dispositivos — restrições e premissas vivem em §2.4/§2.5)
  6. Rastreabilidade (esboço — matriz completa gerada em [B3])
  7. Conflitos (condicional)
  8. Glossário
- Sem interação com usuário

#### [A4] traducao-gate

- Invocar skill 'traducao-gate'
- Input: `documentos-tecnicos/03-documento/03-srs-completo.md` (versão normativa gerada em [A3]) + bloco leigo-safe de `documentos-tecnicos/03-documento/03.3-diagramas.md`
- Output: `documentos-para-leigo/03-documento/03-documento-do-projeto.md` — versão em linguagem natural, sem jargão técnico ou de ER, com seção visual ("Como o produto funciona visualmente") quando os diagramas existirem
- Atualizar `estado-projeto.yaml` após concluir todos os artefatos da Fase A

---

### FASE B — Sub-agente: checker

#### [B1] validacao-checklist-ireb

- Invocar skill 'validacao-checklist-ireb'
- Input: `documentos-tecnicos/03-documento/03-srs-completo.md` + `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` + `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`
- Aplicar 12 critérios IREB §3.8: 6 por requisito individual + 6 por SRS como documento
- Output: seção "Validação IREB §3.8" adicionada ao rascunho de `documentos-tecnicos/03-documento/03.1-analyze-report.md`
- Sem interação com usuário

#### [B2] analyze-cross-artifact

- Invocar skill 'analyze-cross-artifact'
- Input: todos os artefatos M1 + M2 + M3 (inclusive outputs de [B1] já em `documentos-tecnicos/03-documento/03.1-analyze-report.md`)
- Executar 2 cruzamentos obrigatórios:
  1. Visão ↔ Elicitação: objetivo M1 → RF correspondente em M2
  2. Elicitação ↔ SRS: RF/RNF de M2 → seção correspondente no SRS
- Output: seção "Análise Cross-Artifact (D17)" adicionada ao rascunho de `documentos-tecnicos/03-documento/03.1-analyze-report.md`
- Sem interação com usuário

#### [B3] rastreabilidade-matriz

- Invocar skill 'rastreabilidade-matriz'
- Input: `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` + `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` + `documentos-tecnicos/03-documento/03-srs-completo.md`
- Output: `documentos-tecnicos/03-documento/03.2-rastreabilidade.md` com matriz completa Objetivo→RF/RNF→Seção SRS→Stakeholder
- Lacunas (células "❌") alimentam análise final antes da consolidação
- Sem interação com usuário

#### [B4] Consolidar documentos-tecnicos/03-documento/03.1-analyze-report.md

- Reunir seções geradas em [B1], [B2] e lacunas de [B3]
- Ordenar todos os issues: CRITICAL → HIGH → MEDIUM → LOW
- Adicionar cabeçalho ao `documentos-tecnicos/03-documento/03.1-analyze-report.md` com:
  - Total de issues por severidade
  - Decisão: "BLOQUEADO — Gate 3 não pode abrir" (se CRITICAL > 0) ou "APROVADO — Gate 3 pronto" (se CRITICAL = 0)
- Salvar `documentos-tecnicos/03-documento/03.1-analyze-report.md` na pasta do projeto

---

## REGRAS DO LOOP M3

1. **Loop dinâmico:** encerra automaticamente quando `analyze-report.md` não tiver issues CRITICAL (convergência). CRITICAL é bloqueador — o Gate 3 não abre com CRITICAL aberto. A partir da 3ª rodada, se CRITICAL persistir, oferecer ao usuário (choice): `"Continuar agora"` → nova rodada | `"Pausar e retomar depois"` → salvar estado e encerrar amigavelmente (a retomada via `/iniciar-produto` continua o loop). Nunca oferecer "seguir assim".
2. **Documenter modo correção:** recebe `documentos-tecnicos/03-documento/03.1-analyze-report.md` com lista de CRITICAL; executa **apenas** as skills afetadas (não refaz toda a Fase A)
   - Issues IREB §3.8 → refazer [A1] e/ou [A3] para os RFs/RNFs afetados
   - Issues de diagramas → refazer [A2] e [A3]
   - Sempre refazer [A4] (traducao-gate) ao final de qualquer correção que tenha refeito [A1]/[A2]/[A3] — a versão leigo nunca pode ficar desatualizada em relação ao SRS apresentado no gate
3. **Checker reexecuta [B1]–[B3]** após cada rodada de correção do documenter
4. **Contador de iterações:** registrar em `estado-projeto.yaml` campo `loop_m3_iteracoes: N`; incrementar a cada retorno ao documenter
5. **A partir da 3ª rodada com CRITICAL:** orquestrador oferece ao usuário via `AskUserQuestion` (choice) continuar agora ou pausar e retomar depois — CRITICAL aberto nunca avança para o gate

---

## ARTEFATOS GERADOS

| Arquivo | Fase | Obrigatório | Tamanho esperado |
|---|---|---|---|
| `documentos-tecnicos/03-documento/03-srs-completo.md` | Fase A — [A3] | Sim | 8 seções IREB; 500–1500 palavras |
| `documentos-para-leigo/03-documento/03-documento-do-projeto.md` | Fase A — [A4] | Sim | Versão leigo do SRS; 300–800 palavras |
| `documentos-tecnicos/03-documento/03.3-diagramas.md` | Fase A — [A2] | Condicional | 3 diagramas Mermaid + bloco leigo-safe |
| `documentos-tecnicos/03-documento/03.1-analyze-report.md` | Fase B — [B1]–[B4] | Sim | Issues CRITICAL/HIGH/MEDIUM/LOW; cabeçalho com totais |
| `documentos-tecnicos/03-documento/03.2-rastreabilidade.md` | Fase B — [B3] | Condicional | Matriz completa; seção de resumo de gaps |

---

## REGRAS TRANSVERSAIS (válidas em todos os passos)

- Invocar `traducao-leigo` antes de qualquer texto apresentado ao usuário (D19)
- Artefatos internos/técnicos de M3 (`03.1-analyze-report.md`, `03.2-rastreabilidade.md`, `03.3-diagramas.md`) não recebem versão leigo separada — o bloco leigo-safe dos diagramas é embutido no documento leigo por [A4]
- Batching ≤ 4 perguntas por `AskUserQuestion` (D14)
- Nunca mencionar "requisito", "elicitação", "stakeholder", "SRS" ao usuário leigo
- Se usuário abortar em qualquer passo: salvar `.draft` dos artefatos em andamento + registrar em `_pendencias.md`
- O checker **não interage com o usuário no Modo M3** — toda comunicação com o usuário passa pelo orquestrador

---

## TRANSIÇÕES DE ESTADO (estado-projeto.yaml)

| Momento | Campo atualizado |
|---|---|
| Início do workflow | `marco_corrente: M3`, `gate_status.gate_3: pendente`, `loop_m3_iteracoes: 0` |
| Após [A2] modelagem-visual | `modelagem_visual_gerada: true`, `artefatos: [..., documentos-tecnicos/03-documento/03.3-diagramas.md]` |
| Após [A3] srs-ireb-montagem | `artefatos: [..., documentos-tecnicos/03-documento/03-srs-completo.md]` |
| Após [A4] traducao-gate | `artefatos: [..., documentos-para-leigo/03-documento/03-documento-do-projeto.md]`, `fase_a_concluida: true` |
| Início Fase B iteração N | `loop_m3_iteracoes: N` |
| Após [B3] rastreabilidade-matriz | `artefatos: [..., documentos-tecnicos/03-documento/03.2-rastreabilidade.md]` |
| Após [B4] consolidação | `artefatos: [..., documentos-tecnicos/03-documento/03.1-analyze-report.md]` |
| Gate 3 aprovado | `gate_status.gate_3: aprovado`, `versao_leigo_aprovada: [documentos-para-leigo/03-documento/03-documento-do-projeto.md]` |
| Gate 3 reprovado | `gate_status.gate_3: pendente` (permanece; feedback do usuário registrado) |
