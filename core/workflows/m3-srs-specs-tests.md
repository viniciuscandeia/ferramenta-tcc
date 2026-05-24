# Workflow M3 — Detalhamento

**Sub-agentes responsáveis:** `documenter` (Fase A) → `checker` (Fase B, loop de validação)
**Entrada:** artefatos M1 aprovados (Gate 1) + artefatos M2 aprovados (Gate 2)
**Saída:** `documentos-tecnicos/03-documento/03-srs-completo.md` + `documentos-para-leigo/03-documento/03-documento-do-projeto.md` + `documentos-tecnicos/03-documento/04-spec/*.feature` + `documentos-tecnicos/03-documento/04-spec/_skipped.md` + `documentos-tecnicos/03-documento/05-tests/` + `documentos-tecnicos/03-documento/06-estrategia-testes.md` + `documentos-tecnicos/03-documento/07-como-rodar-testes.md` + `documentos-tecnicos/03-documento/03.1-analyze-report.md` + `documentos-tecnicos/03-documento/03.2-rastreabilidade.md`
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
║ [A2] srs-ireb-template           ║  → SRS com 6 seções IREB §3.3.3
║ [A3] gherkin-spec                ║  → spec/*.feature (RFs DEVE) + _skipped.md
║ [A4] step-defs-red               ║  → tests/ RED em 3 frameworks
║ [A5] testing-strategy            ║  → TESTING-STRATEGY.md por RNF
║ [A6] readme-tests                ║  → README-TESTS.md (3 frameworks)
║ [A7] traducao-gate               ║  → SRS-completo-leigo.md
╚═════════════════╤════════════════╝
                  │ 03-srs-completo.md + 04-spec/ + 05-tests/ + ...
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
   (dinâmico)         [GATE 3]
                    SIM → M4 (opcional) ou encerrar
                    NÃO → volta ao documenter com feedback do usuário
```

---

## DETALHES DE CADA PASSO

### FASE A — Sub-agente: documenter

#### [A1] requisito-ears

- Invocar skill `core/skills/requisito-ears/SKILL.md`
- Input: `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` + `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` (artefatos M2 aprovados)
- Output: versões formatadas de cada RF e RNF no padrão EARS (Event-driven, Ubiquitous, State-driven, Optional, Unwanted behaviour) com modal RFC 2119 (`DEVE` / `DEVERIA` / `PODE`)
- Sem interação com usuário — transformação de formato pura

#### [A2] srs-ireb-template

- Invocar skill `core/skills/srs-ireb-template/SKILL.md`
- Input: RFs+RNFs formatados de [A1] + `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-tecnicos/02-requisitos/02.5-glossario.md`
- Output: `documentos-tecnicos/03-documento/03-srs-completo.md` com 6 seções IREB §3.3.3:
  1. Introdução (escopo, glossário)
  2. Visão geral do sistema
  3. Requisitos funcionais (RFs em EARS + RFC 2119)
  4. Requisitos de qualidade (RNFs com métricas)
  5. Restrições e premissas
  6. Rastreabilidade (esboço — matriz completa gerada em [B3])
- Sem interação com usuário

#### [A3] gherkin-spec

- Invocar skill `core/skills/gherkin-spec/SKILL.md`
- Input: `documentos-tecnicos/03-documento/03-srs-completo.md` (seção 3 — RFs DEVE)
- Output:
  - `documentos-tecnicos/03-documento/04-spec/rf-{id}-{descricao}.feature` para cada RF com modal `DEVE` (1 arquivo por RF)
  - `documentos-tecnicos/03-documento/04-spec/_skipped.md` listando todos os RFs com modal `DEVERIA` ou `PODE` (intencionalmente sem spec)
- Formato Gherkin: Given/When/Then; cenário feliz + ≥ 1 cenário alternativo por RF DEVE
- Sem interação com usuário

#### [A4] step-defs-red

- Invocar skill `core/skills/step-defs-red/SKILL.md`
- Input: `documentos-tecnicos/03-documento/04-spec/*.feature` (gerados em [A3])
- Output: `documentos-tecnicos/03-documento/05-tests/` com step definitions em estado RED nos 3 frameworks declarados:
  - Playwright (E2E / UI)
  - pytest-bdd (Python, lógica de negócio)
  - Cucumber/JUnit (integração Java, se aplicável)
- Step defs devem falhar intencionalmente (RED = sem implementação real) — confirmar ausência de falsos passes
- Sem interação com usuário

#### [A5] testing-strategy

- Invocar skill `core/skills/testing-strategy/SKILL.md`
- Input: `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` (RNFs com métricas)
- Output: `documentos-tecnicos/03-documento/06-estrategia-testes.md` com 1 entrada por RNF declarando:
  - Tipo de teste (performance, segurança, acessibilidade, etc.)
  - Ferramenta recomendada (k6, OWASP ZAP, Lighthouse, etc.)
  - Critério de aceite derivado da métrica do RNF
  - Quando executar (CI, pré-deploy, etc.)
- Sem interação com usuário

#### [A6] readme-tests

- Invocar skill `core/skills/readme-tests/SKILL.md`
- Input: `documentos-tecnicos/03-documento/05-tests/` + `documentos-tecnicos/03-documento/06-estrategia-testes.md`
- Output: `documentos-tecnicos/03-documento/07-como-rodar-testes.md` com:
  - Instruções de setup para cada um dos 3 frameworks
  - Comandos de execução exatos (copiáveis)
  - Como interpretar resultados RED (estado esperado pré-implementação)
  - Referência a `documentos-tecnicos/03-documento/06-estrategia-testes.md` para testes de RNF
- Sem interação com usuário

#### [A7] traducao-gate

- Invocar skill `core/skills/traducao-gate/SKILL.md`
- Input: `documentos-tecnicos/03-documento/03-srs-completo.md` (versão normativa gerada em [A2])
- Output: `documentos-para-leigo/03-documento/03-documento-do-projeto.md` — versão em linguagem natural, sem jargão técnico ou de ER
- **Exceção D18+D19:** `04-spec/`, `05-tests/`, `06-estrategia-testes.md` e `07-como-rodar-testes.md` são artefatos técnicos — não gerar versões leigo destes
- Atualizar `estado-projeto.yaml` após concluir todos os artefatos da Fase A

---

### FASE B — Sub-agente: checker

#### [B1] validacao-checklist-ireb

- Invocar skill `core/skills/validacao-checklist-ireb/SKILL.md`
- Input: `documentos-tecnicos/03-documento/03-srs-completo.md` + `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` + `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md`
- Aplicar 12 critérios IREB §3.8: 6 por requisito individual + 6 por SRS como documento
- Output: seção "Validação IREB §3.8" adicionada ao rascunho de `documentos-tecnicos/03-documento/03.1-analyze-report.md`
- Sem interação com usuário

#### [B2] analyze-cross-artifact

- Invocar skill `core/skills/analyze-cross-artifact/SKILL.md`
- Input: todos os artefatos M1 + M2 + M3 (inclusive outputs de [B1] já em `documentos-tecnicos/03-documento/03.1-analyze-report.md`)
- Executar 3 cruzamentos obrigatórios:
  1. Visão ↔ Elicitação: objetivo M1 → RF correspondente em M2
  2. Elicitação ↔ SRS: RF/RNF de M2 → seção correspondente no SRS
  3. SRS ↔ Spec: RF DEVE no SRS → `.feature` correspondente em `04-spec/`
- Output: seção "Análise Cross-Artifact (D17)" adicionada ao rascunho de `documentos-tecnicos/03-documento/03.1-analyze-report.md`
- Sem interação com usuário

#### [B3] rastreabilidade-matriz

- Invocar skill `core/skills/rastreabilidade-matriz/SKILL.md`
- Input: `documentos-tecnicos/01-visao/01-visao-produto.md` + `documentos-tecnicos/02-requisitos/02.1-requisitos-funcionais.md` + `documentos-tecnicos/02-requisitos/02.2-requisitos-qualidade.md` + `documentos-tecnicos/03-documento/03-srs-completo.md` + `documentos-tecnicos/03-documento/04-spec/*.feature`
- Output: `documentos-tecnicos/03-documento/03.2-rastreabilidade.md` com matriz completa Objetivo→RF/RNF→Seção SRS→Spec→Test→Stakeholder
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

1. **Loop dinâmico:** encerra automaticamente quando `analyze-report.md` não tiver issues CRITICAL (convergência). A partir da 3ª rodada, se CRITICAL persistir, escalar ao usuário (yesno: "Ainda há pontos que precisam revisão — quer continuar ajustando ou prefere seguir assim?"). Se SIM → nova rodada. Se NÃO → avançar para gate.
2. **Documenter modo correção:** recebe `documentos-tecnicos/03-documento/03.1-analyze-report.md` com lista de CRITICAL; executa **apenas** as skills afetadas (não refaz toda a Fase A)
   - Issues IREB §3.8 → refazer [A1] e/ou [A2] para os RFs/RNFs afetados
   - Issues de spec ausente → refazer [A3] para os RFs afetados (em `04-spec/`)
   - Issues de step defs → refazer [A4] para os `.feature` afetados (em `05-tests/`)
3. **Checker reexecuta [B1]–[B3]** após cada rodada de correção do documenter
4. **Contador de iterações:** registrar em `estado-projeto.yaml` campo `loop_m3_iteracoes: N`; incrementar a cada retorno ao documenter
5. **A partir da 3ª rodada com CRITICAL:** orquestrador escala ao usuário via `AskUserQuestion` (yesno) antes de continuar ou encerrar

---

## ARTEFATOS GERADOS

| Arquivo | Fase | Obrigatório | Tamanho esperado |
|---|---|---|---|
| `documentos-tecnicos/03-documento/03-srs-completo.md` | Fase A — [A2] | Sim | 6 seções IREB; 500–1500 palavras |
| `documentos-para-leigo/03-documento/03-documento-do-projeto.md` | Fase A — [A7] | Sim | Versão leigo do SRS; 300–800 palavras |
| `documentos-tecnicos/03-documento/04-spec/*.feature` | Fase A — [A3] | Sim (1 por RF DEVE) | 1 cenário feliz + ≥ 1 alternativo por arquivo |
| `documentos-tecnicos/03-documento/04-spec/_skipped.md` | Fase A — [A3] | Sim | Lista de RFs DEVERIA/PODE sem spec (pode ser vazio) |
| `documentos-tecnicos/03-documento/05-tests/` | Fase A — [A4] | Sim | Step defs RED em ≥ 2 frameworks |
| `documentos-tecnicos/03-documento/06-estrategia-testes.md` | Fase A — [A5] | Sim | 1 entrada por RNF DEVE |
| `documentos-tecnicos/03-documento/07-como-rodar-testes.md` | Fase A — [A6] | Sim | Setup + comandos para os 3 frameworks |
| `documentos-tecnicos/03-documento/03.1-analyze-report.md` | Fase B — [B1]–[B4] | Sim | Issues CRITICAL/HIGH/MEDIUM/LOW; cabeçalho com totais |
| `documentos-tecnicos/03-documento/03.2-rastreabilidade.md` | Fase B — [B3] | Sim | Matriz completa; seção de resumo de gaps |

---

## REGRAS TRANSVERSAIS (válidas em todos os passos)

- Invocar `traducao-leigo` antes de qualquer texto apresentado ao usuário (D19) — exceto artefatos técnicos (D18)
- Exceção D18+D19: `04-spec/`, `05-tests/`, `06-estrategia-testes.md`, `07-como-rodar-testes.md` são artefatos técnicos — exibir ao usuário apenas se solicitado
- Batching ≤ 4 perguntas por `AskUserQuestion` (D14)
- Nunca mencionar "requisito", "elicitação", "stakeholder", "SRS", "spec", "Gherkin", "step definitions" ao usuário leigo
- Se usuário abortar em qualquer passo: salvar `.draft` dos artefatos em andamento + registrar em `_pendencias.md`
- O checker **não interage com o usuário no Modo M3** — toda comunicação com o usuário passa pelo orquestrador

---

## TRANSIÇÕES DE ESTADO (estado-projeto.yaml)

| Momento | Campo atualizado |
|---|---|
| Início do workflow | `marco_corrente: M3`, `gate_status.gate_3: pendente`, `loop_m3_iteracoes: 0` |
| Após [A2] srs-ireb-template | `artefatos: [..., documentos-tecnicos/03-documento/03-srs-completo.md]` |
| Após [A3] gherkin-spec | `artefatos: [..., documentos-tecnicos/03-documento/04-spec/]` |
| Após [A4] step-defs-red | `artefatos: [..., documentos-tecnicos/03-documento/05-tests/]` |
| Após [A5] testing-strategy | `artefatos: [..., documentos-tecnicos/03-documento/06-estrategia-testes.md]` |
| Após [A6] readme-tests | `artefatos: [..., documentos-tecnicos/03-documento/07-como-rodar-testes.md]` |
| Após [A7] traducao-gate | `artefatos: [..., documentos-para-leigo/03-documento/03-documento-do-projeto.md]`, `fase_a_concluida: true` |
| Início Fase B iteração N | `loop_m3_iteracoes: N` |
| Após [B3] rastreabilidade-matriz | `artefatos: [..., documentos-tecnicos/03-documento/03.2-rastreabilidade.md]` |
| Após [B4] consolidação | `artefatos: [..., documentos-tecnicos/03-documento/03.1-analyze-report.md]` |
| Gate 3 aprovado | `gate_status.gate_3: aprovado`, `versao_leigo_aprovada: [documentos-para-leigo/03-documento/03-documento-do-projeto.md]` |
| Gate 3 reprovado | `gate_status.gate_3: pendente` (permanece; feedback do usuário registrado) |
