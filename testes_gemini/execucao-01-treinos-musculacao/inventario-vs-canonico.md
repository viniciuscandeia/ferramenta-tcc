# Inventário: Gerado vs. Esperado — Execução 01

**Veredicto:** reprovada. 4 arquivos com nome fora do canônico, ~18 artefatos esperados ausentes.

---

## Marco 1 — Definição da Necessidade

**Agente canônico:** `stakeholder-identifier`
**Skills esperadas:** `vision-box` → `situacao-problema` → `stakeholder-mapping` → `contexto-e-limite` → `traducao-leigo` → `traducao-gate`

| Arquivo esperado | Arquivo gerado | Status | Observação |
|---|---|---|---|
| `visao-produto-leigo.md` | — | ❌ AUSENTE | Produzido por `traducao-gate` ao final do marco |
| `visao-produto-normativo.md` | — | ❌ AUSENTE | Produzido por `traducao-gate` ao final do marco |
| — | `vision-box.md` | ❌ NOME PROIBIDO | Listado explicitamente como inválido em `m1.md:40`. É nome de skill, não de artefato |

**Gate 1:** não passou por verificação real — C4.4 deveria ter bloqueado `vision-box.md`.

---

## Marco 2 — Consenso de Escopo

**Agentes canônicos:** `collector` ⇄ `modeler` (loop, 5 rondas: entrevista, cenários, domínio, implícitos, feixe)
**Skills de loop:** `entrevista-estruturada`, `cenario-narrativa`, `recomendacao-dominio`, `recomendacao-implicitos`, `questionario-feixe`, `classificacao-rf-rnf`, `priorizacao`, `glossario`, `pautas-reelicitacao`, `conflitos-detect`, `traducao-leigo`, `traducao-gate`

| Arquivo esperado | Obrigatório | Arquivo gerado | Status |
|---|---|---|---|
| `elicitacao-raw.md` | Sim | — | ❌ AUSENTE |
| `03.1-funcionais.md` | Sim | — | ❌ AUSENTE |
| `03.1-funcionais-leigo.md` | Sim | — | ❌ AUSENTE |
| `03.2-qualidade.md` | Sim | — | ❌ AUSENTE |
| `03.2-qualidade-leigo.md` | Sim | — | ❌ AUSENTE |
| `03.3-restricoes.md` | Sim | — | ❌ AUSENTE |
| `03.3-restricoes-leigo.md` | Sim | — | ❌ AUSENTE |
| `glossario.md` | Sim (≥1 entrada) | — | ❌ AUSENTE |
| `pautas-reelicitacao.md` | Sim (sem `[ ]`) | ✓ presente | ⚠ sem `(skill-alvo: <nome>)` em cada item |
| `03.4-premissas.md` | Condicional | — | n/a |
| `conflitos-detectados.md` | Condicional | — | n/a |
| — | — | `necessidades.md` | ❌ NOME PROIBIDO (listado inválido em `m1.md:40`; conteúdo é M2) |
| — | — | `fluxos.md` | ❌ NOME PROIBIDO (listado inválido) |

**Gate 2:** `loop_m2_iteracoes` provavelmente 0 (nenhuma das 5 rondas rastreada em arquivo).

---

## Marco 3 — Detalhamento

**Agentes canônicos:** `documenter` ⇄ `checker` (loop, skills técnicas)
**Skills:** `requisito-ears`, `srs-ireb-template`, `gherkin-spec`, `step-defs-red`, `testing-strategy`, `readme-tests`, `analyze-cross-artifact`, `validacao-checklist-ireb`, `rastreabilidade-matriz`

| Arquivo esperado | Obrigatório | Arquivo gerado | Status |
|---|---|---|---|
| `SRS-completo.md` | Sim (6 seções IREB §3.3.3) | — | ❌ AUSENTE |
| `SRS-completo-leigo.md` | Sim (Gate 3) | — | ❌ AUSENTE |
| `spec/*.feature` | Sim (≥1 para RF DEVE) | — | ❌ AUSENTE |
| `spec/_skipped.md` | Sim | — | ❌ AUSENTE |
| `tests/unit/` | Sim (≥1 arquivo) | — | ❌ AUSENTE |
| `tests/acceptance/` | Sim (≥1 arquivo) | — | ❌ AUSENTE |
| `TESTING-STRATEGY.md` | Sim | — | ❌ AUSENTE |
| `README-TESTS.md` | Sim | — | ❌ AUSENTE |
| `analyze-report.md` | Sim (0 CRITICAL) | ✓ presente | ⚠ raso — 14 linhas; faltam 3 Cruzamentos canônicos; sem categorização Omissão/Contradição/Superespecificação/Inexequibilidade |
| `rastreabilidade.md` | Condicional | — | ❌ skill `rastreabilidade-matriz` não rodou |
| — | — | `srs.md` (4 seções) | ❌ NOME PROIBIDO; canônico = `SRS-completo.md`; apenas 4 seções IREB, sem EARS formal |

**Gate 3:** tecnicamente passou (0 CRITICAL no `analyze-report.md`), mas toda camada técnica ausente.

---

## Marco 4 — Revisão Técnica (opcional, D24)

**Agente:** `checker` (modo técnico)
**Pre-requisito:** só inicia se tech lead solicitar explicitamente

| Arquivo esperado | Arquivo gerado | Status |
|---|---|---|
| `revisao-tecnica.md` | — | ❌ AUSENTE — deveria preceder a aprovação |
| `aprovacao-tecnica.md` | ✓ presente | ⚠ prematuro — declara "Autorizado para Desenvolvimento" sem `revisao-tecnica.md`; sem identificação do tech lead (D24 exige assinatura) |

---

## `estado-projeto.yaml` — conformidade

| Campo esperado | Valor gerado | Status |
|---|---|---|
| `gate_4_status: aprovado` | `gate_4_status: pendente` | ❌ conflita com `aprovacao-tecnica.md` em disco |
| `m4.status: concluido` | `m4.status: em_progresso` | ❌ inconsistente com aprovação presente |
| `loop_m2_iteracoes ≥ 1` | ausente | ❌ AUSENTE |
| `loop_m3_iteracoes ≥ 1` | ausente | ❌ AUSENTE |
| `agenda_m2` (5 rondas) | ausente | ❌ AUSENTE |
| `passes[]` (pass-log Z20) | ausente | ❌ AUSENTE |
| `documentos` inclui todos 8 artefatos | inclui 4 de 8 | ⚠ `analyze-report.md`, `pautas-reelicitacao.md`, `aprovacao-tecnica.md`, `estado-projeto.yaml` não listados |

---

## Resumo quantitativo

| Categoria | Quantidade |
|---|---|
| Artefatos presentes e conformes | 1 (`pautas-reelicitacao.md` — conteúdo OK, formato ⚠) |
| Artefatos presentes mas rasos / fora do canônico | 3 (`vision-box.md`, `srs.md`, `analyze-report.md`, `aprovacao-tecnica.md`) |
| Artefatos obrigatórios ausentes | ~15 |
| Arquivos com nome proibido | 4 (`vision-box.md`, `necessidades.md`, `fluxos.md`, `srs.md`) |
| Issues no `estado-projeto.yaml` | 6 |
