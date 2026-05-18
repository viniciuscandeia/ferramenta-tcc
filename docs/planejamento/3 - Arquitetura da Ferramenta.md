# Arquitetura da Ferramenta — Documento Canônico

**Data:** 2026-05-17  
**Versão:** 2.0 (redesign pós-pesquisa de mercado)  
**Substitui:** referências a `docs/arquitetura-agentes-skills.md` e `docs/decisoes-de-design.md` (nunca escritos)

---

## Contexto e motivação

A ferramenta passou por três rodadas de decisão (D1–D11 brainstorming, D12–D19 pesquisa de mercado, D20–D24 extensão SDD/TDD), totalizando **24 decisões**. A topologia originalmente proposta — **6 agentes-etapa + 5 sub-agentes transversais + ~30 skills** — ficou descalibrada em relação aos padrões reais de mercado (Spec Kit: ~6 comandos; Spec-Flow: engine + adapter; MARE paper: 5 agentes funcionais) e nunca foi consolidada num único documento. Este é o primeiro documento canônico de arquitetura.

A ferramenta conduz um **stakeholder leigo (D1)** por perguntas-respostas estruturadas (`ask_user` / `AskUserQuestion`) ao longo de **4 marcos**, produzindo:
- SRS no padrão IREB §3.3.3 (ISO/IEC/IEEE 29148)
- Specs Gherkin para RFs com modal `DEVE` (D20/D22)
- Step definitions em estado RED (D20)
- `TESTING-STRATEGY.md` por RNF (D21)
- `README-TESTS.md` para 3 frameworks (D23)

Executa via **Gemini CLI E Claude Code (D11)** com **engine canônico em `core/` + adapters finos (D12)**.

**Prazo:** 2026-07-01

---

## Decisões preservadas

Todas as 24 decisões (D1–D24) permanecem como **constituição** da ferramenta (D15). Única mudança na topologia operacional:

**D6 revisada (2026-05-17):** em vez de 6 sub-agentes transversais (Implícitos/Conflitos/NLP/Visualização/Recomendação/Gerência), adotam-se **5 sub-agentes funcionais MARE-style** + redistribuição como skills compartilhadas. Justificativa: alinha com MARE (arXiv 2405.03256); reduz de 11 para 6 unidades (−45%).

---

## Topologia geral

```
USUÁRIO LEIGO
     │
     │  /iniciar-projeto   ← único entry-point
     ▼
┌─────────────────────────────────────────────┐
│ ORQUESTRADOR (core/orchestrator.md)         │
│ • Lê constitution.md + estado-projeto.yaml  │
│ • Roteia para marco corrente                │
│ • Gerencia 4 gates                          │
│ • Baseline git após cada gate aprovado      │
└────┬────────────────────────────────────────┘
     │
     ▼  (MARE-style, em sequência por marco)
┌─────────────────────────────────────────────┐
│ 5 SUB-AGENTES FUNCIONAIS ER (core/agents/)  │
│                                             │
│  M1 ──► stakeholder-identifier              │
│  M2 ──► collector ⇄ modeler (loop interno)  │
│  M3 ──► documenter ⇄ checker (loop interno) │
│  M4 ──► checker (modo técnico) — D24        │
└────┬────────────────────────────────────────┘
     │
     ▼  (sob demanda por sub-agente)
┌─────────────────────────────────────────────┐
│ ~22 SKILLS (core/skills/)                   │
│ + 4 skills transversais                     │
└─────────────────────────────────────────────┘

CATÁLOGOS SEED (ferramenta-tcc/catalogos-seed/)
└─ consumidos pelas skills de recomendação
```

### Compatibilidade de plataforma

| Mecanismo | Claude Code | Gemini CLI |
|---|---|---|
| Sub-agentes | `Task()` / `context: fork` (processo isolado) | Persona adoption (mesmo contexto) |
| Skills | Frontmatter Claude + auto-detecção | Frontmatter Gemini + match de descrição |
| Entry-point | `/iniciar-projeto` (slash command) | `/iniciar-projeto` (comando) |
| Perguntas interativas | `AskUserQuestion` | `ask_user` (choice/text/yesno; ≤4/lote) |
| Estado | `estado-projeto.yaml` (D13) + detection-based D10 | Idem |

---

## Layout de arquivos

```
ferramenta-tcc/
├── core/                                      ← engine canônico (D12)
│   ├── orchestrator.md                        ← orquestrador único
│   ├── constitution.md                        ← D15: guardrail imutável
│   ├── agents/
│   │   ├── stakeholder-identifier.md          ← M1
│   │   ├── collector.md                       ← M2: elicitação
│   │   ├── modeler.md                         ← M2: classificação/priorização
│   │   ├── checker.md                         ← M3+M4: validação
│   │   └── documenter.md                      ← M3: gera 5 outputs
│   ├── skills/                                ← ~22 skills + 4 transversais
│   └── workflows/
│       ├── m1-visao.md
│       ├── m2-requisitos.md
│       └── m3-srs-specs-tests.md
│
├── .claude/                                   ← adapter Claude Code
│   ├── agents/                                ← wrappers finos para core/agents/
│   ├── skills/                                ← frontmatter Claude
│   ├── commands/iniciar-projeto.md
│   └── .claude-plugin/plugin.json
│
├── .gemini/                                   ← adapter Gemini CLI
│   ├── agents/
│   ├── skills/
│   ├── commands/iniciar-projeto.toml
│   └── gemini-extension.json
│
├── catalogos-seed/                            ← já existe
│   ├── stakeholders-tipicos.md
│   ├── rfs-tipicos.md
│   ├── rnfs-tipicos.md
│   ├── restricoes-tipicas.md
│   └── dominios/{educacao,mobile,ecommerce,saude,dashboard}.md
│
└── tests/
    ├── marco-1/
    ├── marco-2/
    └── marco-3/
```

---

## Os 5 sub-agentes (MARE-style)

| Sub-agente | Marco(s) | Função | Skills principais |
|---|---|---|---|
| **`stakeholder-identifier`** | M1 | Visão + situação-problema + stakeholders + contexto/limite | `vision-box`, `situacao-problema`, `stakeholder-mapping`, `contexto-e-limite`, `clarificacao-pos-visao` (D16) |
| **`collector`** | M2 | Elicitação: entrevistas, cenários, questionários | `entrevista-estruturada`, `cenario-narrativa`, `questionario-feixe`, `recomendacao-implicitos`, `recomendacao-dominio` |
| **`modeler`** | M2 | Classificação (9 buckets Wiegers + IREB), priorização, glossário, re-elicitação | `classificacao-rf-rnf`, `priorizacao` (D9), `glossario`, `pautas-reelicitacao`, `conflitos-detect` |
| **`checker`** | M3 + M4 | Validação IREB §3.8, analyze cross-artifact (D17), revisão técnica M4 | `validacao-checklist-ireb`, `analyze-cross-artifact`, `rastreabilidade-matriz` |
| **`documenter`** | M3 | Gera os 5 outputs finais | `requisito-ears`, `srs-ireb-template`, `gherkin-spec` (D20), `step-defs-red` (D20), `testing-strategy` (D21), `readme-tests` (D23) |

---

## Inventário de skills (~22 skills + 4 transversais)

### Marco 1 — Definição da Necessidade (5 skills)

| Skill | Referência |
|---|---|
| `vision-box` | Material Dani `ers-apoio-marco-01-visao-do-produto.md` |
| `situacao-problema` | Material Dani `ers-apoio-projeto-situacao-problema.md` |
| `stakeholder-mapping` | Livro 2, cap. 1 |
| `contexto-e-limite` | IREB §3.3.3 Parte II |
| `clarificacao-pos-visao` | D16 — ≤3 perguntas, só se ≥2 lacunas críticas |

### Marco 2 — Consenso de Escopo (8 skills)

| Skill | Referência |
|---|---|
| `entrevista-estruturada` | IREB §4.2 + 4 perguntas-âncora Dani |
| `cenario-narrativa` | Material Dani n08 |
| `questionario-feixe` | — |
| `classificacao-rf-rnf` | IREB §1.1 + 9 buckets Wiegers Ch7 |
| `priorizacao` | D9: MoSCoW (MVP) + Kano + IEEE (sub-rotinas) |
| `glossario` | Wiegers Ch11 (anti-ambiguidade) |
| `pautas-reelicitacao` | Livro SON cap. 8 Fig. 8.3 |
| `conflitos-detect` | IREB §4.4 (6 tipos + 4 estratégias) |

### Marco 3 — Detalhamento (8 skills)

| Skill | Referência |
|---|---|
| `requisito-ears` | D8: EARS + slots + RFC 2119 |
| `srs-ireb-template` | IREB §3.3.3 (6 seções) |
| `validacao-checklist-ireb` | IREB §3.8 (6+6 critérios) |
| `rastreabilidade-matriz` | Matriz D/R |
| `gherkin-spec` | D20/D22: Gherkin para RFs `DEVE` |
| `step-defs-red` | D20: Pytest-BDD / Cucumber-js / SpecFlow |
| `testing-strategy` | D21: estratégia por RNF (categoria/ferramenta/métrica) |
| `readme-tests` | D23: README para 3 frameworks |

### Skills transversais (4)

| Skill | Decisão | Função |
|---|---|---|
| `traducao-leigo` | D19 | Blacklist enforcement + reescrita em linguagem de negócio |
| `traducao-gate` | D18 | Gera versão leigo + normativa por artefato-gate |
| `analyze-cross-artifact` | D17 | Consistência Visão↔Elicitação↔SRS; CRITICAL/HIGH/MEDIUM/LOW |
| `recomendacao-implicitos` + `recomendacao-dominio` | D6 rev. | Leem `catalogos-seed/`; absorvem ex-sub-agentes Implícitos e Recomendação |

**Total:** ~22 skills (vs. ~30 originais) + 1 orquestrador + 5 sub-agentes (vs. 11 agentes originais).

---

## 4 marcos e gates

| Marco | Sub-agentes ativos | Artefatos esperados | Gate |
|---|---|---|---|
| **M1 — Definição da Necessidade** | `stakeholder-identifier` | `visao-produto.md` (2 versões: leigo + normativa) | Gate 1: leigo aprova versão leigo |
| **M2 — Consenso de Escopo** | `collector` ⇄ `modeler` (loop) | `03.1-funcionais.md`, `03.2-qualidade.md`, `glossario.md`, `pautas-reelicitacao.md` — 2 versões | Gate 2: leigo aprova; **bloqueado** se `pautas-reelicitacao.md` tem pendências |
| **M3 — Detalhamento** | `documenter` ⇄ `checker` (loop) | `SRS-completo.md` + `spec/*.feature` + `tests/{unit,acceptance}/` + `TESTING-STRATEGY.md` + `README-TESTS.md` + `analyze-report.md` | Gate 3: leigo aprova versão leigo do SRS; CRITICAL do analyze bloqueia |
| **M4 — Revisão Técnica (D24, opcional)** | `checker` (modo técnico) | `revisao-tecnica.md` + `aprovacao-tecnica.md` | Gate 4: desenvolvedor/tech lead aprova |

Loops **dentro de** marco: permitidos. Entre marcos: só após gate aprovado. Orquestrador cria baseline (snapshot + tag git) após cada gate.

---

## Padrões de governança adotados

| Padrão | Decisão | Descrição |
|---|---|---|
| `constitution.md` | D15 | Guardrail imutável: D1 blacklist + resumo D1–D24 + regras de batching + política de gates. Carregado pelo orquestrador na abertura de cada sessão. Versionado no git. |
| `estado-projeto.yaml` | D13 + D10 | SoT primário: `marco_corrente`, `gate_status`, `artefatos[]`, `pautas_abertas[]`, `versao_leigo_aprovada[]`. Detection-based (D10) como fallback. Yaml vence em conflito. |
| Question batching ≤4 | D14 | Toda skill agrega perguntas antes de invocar `ask_user`. Proibido invocar individualmente por gap detectado. |
| Versão leigo + normativa | D18 + D19 | Todo artefato-gate em 2 versões. `traducao-gate` produz versão leigo. `traducao-leigo` garante zero termos da blacklist D1. |
| Cross-artifact analyze | D17 | Pré-Gate 3: consistência Visão↔Elicitação↔SRS. CRITICAL bloqueia; HIGH/MEDIUM/LOW informativo. |

---

## O que NÃO está neste MVP

- **Sub-agentes transversais separados** (Implícitos/Conflitos/NLP/Visualização/Recomendação/Gerência): redistribuídos como skills ou absorvidos pelo orquestrador.
- **Visualização** (diagramas, matrizes gráficas): v2.
- **Party Mode** (agentes paralelos BMAD-style): requer `Task()` paralelo; inviável no Gemini CLI e no prazo.
- **OpenAPI generation**: D22 fixou Gherkin como único formato; OpenAPI é evolução v2.
- **Skills stretch** (`casos-de-uso`, `complexity-analysis`, `historia-de-usuario`, `requisito-smart`, `requisito-qualidade-furps`): só com folga após Semana 5.
- **Marco 4** é opcional: ferramenta entrega após Gate 3 mesmo sem M4; M4 é próxima etapa recomendada.

---

## Referências cruzadas

| Componente | Referência principal |
|---|---|
| Todas as 24 decisões + justificativas | `docs/planejamento/1 - Decisões Tomadas.md` |
| Cronograma semana-a-semana | `docs/planejamento/ROADMAP.md` |
| Vocabulário técnico (agente / skill / primitiva) | `docs/planejamento/2 - Vocabulário Técnico: Agentes, Skills e Subagentes.md` |
| Benchmarks de mercado que motivaram a revisão D6 | `docs/pesquisa-mercado/SINTESE.md` |
| Paper MARE (referência peer-reviewed comparável) | `docs/pesquisa-mercado/repos/outros.md` → arXiv 2405.03256 |
| Catálogos seed (já implementados) | `ferramenta-tcc/catalogos-seed/` |
