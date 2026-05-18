# Workflow M3 — Detalhamento

**Sub-agentes responsáveis:** `documenter` (Fase A) → `checker` (Fase B, loop de validação)
**Entrada:** artefatos M1 aprovados (Gate 1) + artefatos M2 aprovados (Gate 2)
**Saída:** `SRS-completo.md` + `SRS-completo-leigo.md` + `spec/*.feature` + `spec/_skipped.md` + `tests/` + `TESTING-STRATEGY.md` + `README-TESTS.md` + `analyze-report.md` + `rastreabilidade.md`
**Gate de saída:** Gate 3 — usuário aprova `SRS-completo-leigo.md`; `analyze-report.md` sem issues CRITICAL

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
║ [A2] srs-ireb-template           ║  → SRS com 6 seções IREB §3.3.3
║ [A3] gherkin-spec                ║  → spec/*.feature (RFs DEVE) + _skipped.md
║ [A4] step-defs-red               ║  → tests/ RED em 3 frameworks
║ [A5] testing-strategy            ║  → TESTING-STRATEGY.md por RNF
║ [A6] readme-tests                ║  → README-TESTS.md (3 frameworks)
║ [A7] traducao-gate               ║  → SRS-completo-leigo.md
╚═════════════════╤════════════════╝
                  │ SRS-completo.md + spec/ + tests/ + ...
                  ▼
╔══════════════════════════════════╗
║  FASE B — Validação + Loop       ║  sub-agente: checker
╠══════════════════════════════════╣
║ [B1] validacao-checklist-ireb    ║  → 6+6 critérios IREB §3.8
║ [B2] analyze-cross-artifact      ║  → Visão↔Elicitação↔SRS↔Spec (D17)
║ [B3] rastreabilidade-matriz      ║  → rastreabilidade.md (Objetivo→RF→Spec→Test)
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
   (teto: 3)          [GATE 3]
                    SIM → baseline git → M4 (opcional) ou encerrar
                    NÃO → volta ao documenter com feedback do usuário
```

---

## DETALHES DE CADA PASSO

### FASE A — Sub-agente: documenter

#### [A1] requisito-ears

- Invocar skill `core/skills/requisito-ears/SKILL.md`
- Input: `03.1-funcionais.md` + `03.2-qualidade.md` (artefatos M2 aprovados)
- Output: versões formatadas de cada RF e RNF no padrão EARS (Event-driven, Ubiquitous, State-driven, Optional, Unwanted behaviour) com modal RFC 2119 (`DEVE` / `DEVERIA` / `PODE`)
- Sem interação com usuário — transformação de formato pura

#### [A2] srs-ireb-template

- Invocar skill `core/skills/srs-ireb-template/SKILL.md`
- Input: RFs+RNFs formatados de [A1] + `visao-produto-normativo.md` + `glossario.md`
- Output: `SRS-completo.md` com 6 seções IREB §3.3.3:
  1. Introdução (escopo, glossário)
  2. Visão geral do sistema
  3. Requisitos funcionais (RFs em EARS + RFC 2119)
  4. Requisitos de qualidade (RNFs com métricas)
  5. Restrições e premissas
  6. Rastreabilidade (esboço — matriz completa gerada em [B3])
- Sem interação com usuário

#### [A3] gherkin-spec

- Invocar skill `core/skills/gherkin-spec/SKILL.md`
- Input: `SRS-completo.md` (seção 3 — RFs DEVE)
- Output:
  - `spec/rf-{id}-{descricao}.feature` para cada RF com modal `DEVE` (1 arquivo por RF)
  - `spec/_skipped.md` listando todos os RFs com modal `DEVERIA` ou `PODE` (intencionalmente sem spec)
- Formato Gherkin: Given/When/Then; cenário feliz + ≥ 1 cenário alternativo por RF DEVE
- Sem interação com usuário

#### [A4] step-defs-red

- Invocar skill `core/skills/step-defs-red/SKILL.md`
- Input: `spec/*.feature` (gerados em [A3])
- Output: `tests/` com step definitions em estado RED nos 3 frameworks declarados:
  - Playwright (E2E / UI)
  - pytest-bdd (Python, lógica de negócio)
  - Cucumber/JUnit (integração Java, se aplicável)
- Step defs devem falhar intencionalmente (RED = sem implementação real) — confirmar ausência de falsos passes
- Sem interação com usuário

#### [A5] testing-strategy

- Invocar skill `core/skills/testing-strategy/SKILL.md`
- Input: `03.2-qualidade.md` (RNFs com métricas)
- Output: `TESTING-STRATEGY.md` com 1 entrada por RNF declarando:
  - Tipo de teste (performance, segurança, acessibilidade, etc.)
  - Ferramenta recomendada (k6, OWASP ZAP, Lighthouse, etc.)
  - Critério de aceite derivado da métrica do RNF
  - Quando executar (CI, pré-deploy, etc.)
- Sem interação com usuário

#### [A6] readme-tests

- Invocar skill `core/skills/readme-tests/SKILL.md`
- Input: `tests/` + `TESTING-STRATEGY.md`
- Output: `README-TESTS.md` com:
  - Instruções de setup para cada um dos 3 frameworks
  - Comandos de execução exatos (copiáveis)
  - Como interpretar resultados RED (estado esperado pré-implementação)
  - Referência a `TESTING-STRATEGY.md` para testes de RNF
- Sem interação com usuário

#### [A7] traducao-gate

- Invocar skill `core/skills/traducao-gate/SKILL.md`
- Input: `SRS-completo.md` (versão normativa gerada em [A2])
- Output: `SRS-completo-leigo.md` — versão em linguagem natural, sem jargão técnico ou de ER
- **Exceção D18+D19:** `spec/`, `tests/`, `TESTING-STRATEGY.md` e `README-TESTS.md` são artefatos técnicos — não gerar versões leigo destes
- Atualizar `estado-projeto.yaml` após concluir todos os artefatos da Fase A

---

### FASE B — Sub-agente: checker

#### [B1] validacao-checklist-ireb

- Invocar skill `core/skills/validacao-checklist-ireb/SKILL.md`
- Input: `SRS-completo.md` + `03.1-funcionais.md` + `03.2-qualidade.md`
- Aplicar 12 critérios IREB §3.8: 6 por requisito individual + 6 por SRS como documento
- Output: seção "Validação IREB §3.8" adicionada ao rascunho de `analyze-report.md`
- Sem interação com usuário

#### [B2] analyze-cross-artifact

- Invocar skill `core/skills/analyze-cross-artifact/SKILL.md`
- Input: todos os artefatos M1 + M2 + M3 (inclusive outputs de [B1] já em `analyze-report.md`)
- Executar 3 cruzamentos obrigatórios:
  1. Visão ↔ Elicitação: objetivo M1 → RF correspondente em M2
  2. Elicitação ↔ SRS: RF/RNF de M2 → seção correspondente no SRS
  3. SRS ↔ Spec: RF DEVE no SRS → `.feature` correspondente em `spec/`
- Output: seção "Análise Cross-Artifact (D17)" adicionada ao rascunho de `analyze-report.md`
- Sem interação com usuário

#### [B3] rastreabilidade-matriz

- Invocar skill `core/skills/rastreabilidade-matriz/SKILL.md`
- Input: `visao-produto-normativo.md` + `03.1-funcionais.md` + `03.2-qualidade.md` + `SRS-completo.md` + `spec/*.feature`
- Output: `rastreabilidade.md` com matriz completa Objetivo→RF/RNF→Seção SRS→Spec→Test→Stakeholder
- Lacunas (células "❌") alimentam análise final antes da consolidação
- Sem interação com usuário

#### [B4] Consolidar analyze-report.md

- Reunir seções geradas em [B1], [B2] e lacunas de [B3]
- Ordenar todos os issues: CRITICAL → HIGH → MEDIUM → LOW
- Adicionar cabeçalho ao `analyze-report.md` com:
  - Total de issues por severidade
  - Decisão: "BLOQUEADO — Gate 3 não pode abrir" (se CRITICAL > 0) ou "APROVADO — Gate 3 pronto" (se CRITICAL = 0)
- Salvar `analyze-report.md` na pasta do projeto

---

## REGRAS DO LOOP M3

1. **Teto de 3 iterações:** após 3 execuções do Fase B, se ainda houver CRITICAL, o orquestrador escala ao usuário (yesno: "Ainda há problemas não resolvidos no documento — quer tentar corrigir mais uma vez ou prefere seguir assim?")
2. **Documenter modo correção:** recebe `analyze-report.md` com lista de CRITICAL; executa **apenas** as skills afetadas (não refaz toda a Fase A)
   - Issues IREB §3.8 → refazer [A1] e/ou [A2] para os RFs/RNFs afetados
   - Issues de spec ausente → refazer [A3] para os RFs afetados
   - Issues de step defs → refazer [A4] para os `.feature` afetados
3. **Checker reexecuta [B1]–[B3]** após cada rodada de correção do documenter
4. **Contador de iterações:** registrar em `estado-projeto.yaml` campo `loop_m3_iteracoes: N`; incrementar a cada retorno ao documenter
5. **Se 3ª iteração ainda tem CRITICAL:** orquestrador escala ao usuário via `AskUserQuestion` (yesno) antes de decidir

---

## ARTEFATOS GERADOS

| Arquivo | Fase | Obrigatório | Tamanho esperado |
|---|---|---|---|
| `SRS-completo.md` | Fase A — [A2] | Sim | 6 seções IREB; 500–1500 palavras |
| `SRS-completo-leigo.md` | Fase A — [A7] | Sim | Versão leigo do SRS; 300–800 palavras |
| `spec/*.feature` | Fase A — [A3] | Sim (1 por RF DEVE) | 1 cenário feliz + ≥ 1 alternativo por arquivo |
| `spec/_skipped.md` | Fase A — [A3] | Sim | Lista de RFs DEVERIA/PODE sem spec (pode ser vazio) |
| `tests/` | Fase A — [A4] | Sim | Step defs RED em ≥ 2 frameworks |
| `TESTING-STRATEGY.md` | Fase A — [A5] | Sim | 1 entrada por RNF DEVE |
| `README-TESTS.md` | Fase A — [A6] | Sim | Setup + comandos para os 3 frameworks |
| `analyze-report.md` | Fase B — [B1]–[B4] | Sim | Issues CRITICAL/HIGH/MEDIUM/LOW; cabeçalho com totais |
| `rastreabilidade.md` | Fase B — [B3] | Sim | Matriz completa; seção de resumo de gaps |

---

## REGRAS TRANSVERSAIS (válidas em todos os passos)

- Invocar `traducao-leigo` antes de qualquer texto apresentado ao usuário (D19) — exceto artefatos técnicos (D18)
- Exceção D18+D19: `spec/`, `tests/`, `TESTING-STRATEGY.md`, `README-TESTS.md` são artefatos técnicos — exibir ao usuário apenas se solicitado
- Batching ≤ 4 perguntas por `AskUserQuestion` (D14)
- Nunca mencionar "requisito", "elicitação", "stakeholder", "SRS", "spec", "Gherkin", "step definitions" ao usuário leigo
- Se usuário abortar em qualquer passo: salvar `.draft` dos artefatos em andamento + registrar em `_pendencias.md`
- O checker **não interage com o usuário no Modo M3** — toda comunicação com o usuário passa pelo orquestrador

---

## TRANSIÇÕES DE ESTADO (estado-projeto.yaml)

| Momento | Campo atualizado |
|---|---|
| Início do workflow | `marco_corrente: M3`, `gate_status.gate_3: pendente`, `loop_m3_iteracoes: 0` |
| Após [A2] srs-ireb-template | `artefatos: [..., SRS-completo.md]` |
| Após [A3] gherkin-spec | `artefatos: [..., spec/]` |
| Após [A4] step-defs-red | `artefatos: [..., tests/]` |
| Após [A5] testing-strategy | `artefatos: [..., TESTING-STRATEGY.md]` |
| Após [A6] readme-tests | `artefatos: [..., README-TESTS.md]` |
| Após [A7] traducao-gate | `artefatos: [..., SRS-completo-leigo.md]`, `fase_a_concluida: true` |
| Início Fase B iteração N | `loop_m3_iteracoes: N` |
| Após [B3] rastreabilidade-matriz | `artefatos: [..., rastreabilidade.md]` |
| Após [B4] consolidação | `artefatos: [..., analyze-report.md]` |
| Gate 3 aprovado | `gate_status.gate_3: aprovado`, `versao_leigo_aprovada: [SRS-completo-leigo.md]` |
| Gate 3 reprovado | `gate_status.gate_3: pendente` (permanece; feedback do usuário registrado) |
