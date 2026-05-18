# ROADMAP — Ferramenta de Elicitação de Requisitos

**Prazo final:** 2026-07-01  
**Atualizado em:** 2026-05-17 — redesign arquitetural: D6 revisada para topologia MARE-style (1 orquestrador + 5 sub-agentes + ~22 skills, vs. 11 agentes + ~30 skills originais). Ver `docs/planejamento/3 - Arquitetura da Ferramenta.md`.  
**Auditoria S1–S5 (2026-05-17):** débito `tests/marco-1/` fechado; rótulo "esqueleto" de `stakeholder-identifier` corrigido. Ver plano de auditoria.

---

## Fase 0 — Planejamento ✅

- [x] Pré-projeto escrito e submetido ao orientador (`0 - Ideia Inicial.md`)
- [x] Arquitetura de agentes e skills definida via brainstorming (`docs/arquitetura-agentes-skills.md`)
- [x] Decisões de design registradas (`docs/decisoes-de-design.md`)
- [x] `CLAUDE.md` e `ROADMAP.md` criados

**Próximo passo imediato (Semana 3, início 20/mai):** Criar `core/constitution.md` + `core/orchestrator.md` + esqueletos dos 5 sub-agentes + manifestos `.claude-plugin/plugin.json` e `gemini-extension.json` → depois criar skills M1 → testes E2E Marco 1.

---

## Semana 1 — Setup e seed (06–12/mai) ✅

- [x] Criar repositório `ferramenta-tcc/` com estrutura de pastas
- [x] Criar `ferramenta-tcc/catalogos-seed/stakeholders-tipicos.md`
- [x] Criar `ferramenta-tcc/catalogos-seed/rfs-tipicos.md`
- [x] Criar `ferramenta-tcc/catalogos-seed/rnfs-tipicos.md`
- [x] Criar `ferramenta-tcc/catalogos-seed/restricoes-tipicas.md`
- [x] Criar `ferramenta-tcc/catalogos-seed/dominios/educacao.md`
- [x] Criar `ferramenta-tcc/catalogos-seed/dominios/mobile.md`
- [x] Criar `ferramenta-tcc/catalogos-seed/dominios/ecommerce.md`
- [x] Criar `ferramenta-tcc/catalogos-seed/dominios/saude.md` *(antecipado da Semana 5)*
- [x] Criar `ferramenta-tcc/catalogos-seed/dominios/dashboard.md` *(antecipado da Semana 5)*
- [x] Revisão do IREB §3.3.3 (template SRS) e §3.8 (critérios de qualidade) — extraídos durante leitura
- [x] Criar `ferramenta-tcc/.gemini/gemini-extension.json` (manifesto extensão Gemini CLI) — D11 *(criado em Semana 3)*
- [x] Criar `ferramenta-tcc/.claude/.claude-plugin/plugin.json` (manifesto plugin Claude Code) — D11 *(criado em Semana 3)*

---

## Semana 2 — Planejamento e redesign (13–19/mai) ✅

> **Nota (2026-05-17):** Os itens de implementação originais desta semana (implicitos.md, visao-produto.md, 4 skills em `.gemini/`) foram **supersedidos** pelo redesign arquitetural (D6 revisada). Os arquivos nunca foram criados em disco (só `catalogos-seed/` existe). A Semana 2 entrega o documento canônico de arquitetura em vez da implementação parcial em `.gemini/`.

- [x] Pesquisa de mercado concluída (Spec Kit, Spec-Flow, BMAD, MARE, Specif AI)
- [x] D12–D24 deliberadas e registradas
- [x] `docs/planejamento/3 - Arquitetura da Ferramenta.md` criado (documento canônico)
- [x] `CLAUDE.md` atualizado para topologia MARE-style
- [x] `docs/planejamento/1 - Decisões Tomadas.md` atualizado (D6 revisada)
- [x] `ferramenta-tcc/tests/marco-1/casos.md` (3 casos canônicos) *(recuperado em auditoria S1–S5, 2026-05-17)*
- [x] `ferramenta-tcc/tests/marco-1/checklist.md` (24 critérios)

---

## Semana 3 — Fundação engine + M1 completo (20–26/mai) ✅

### Fundação engine canônico + adapters + governança (D12, D11, D15, D13)
- [x] `ferramenta-tcc/core/constitution.md` *(D15 — guardrail imutável: blacklist D1 + resumo D1–D24)*
- [x] `ferramenta-tcc/core/orchestrator.md` *(entry-point único, rota por marco, 4 gates)*
- [x] `ferramenta-tcc/core/agents/stakeholder-identifier.md` *(M1)*
- [x] `ferramenta-tcc/core/agents/collector.md` *(M2 — esqueleto)*
- [x] `ferramenta-tcc/core/agents/modeler.md` *(M2 — esqueleto)*
- [x] `ferramenta-tcc/core/agents/checker.md` *(M3+M4 — esqueleto)*
- [x] `ferramenta-tcc/core/agents/documenter.md` *(M3 — esqueleto)*
- [x] `ferramenta-tcc/.claude/.claude-plugin/plugin.json` *(D11)*
- [x] `ferramenta-tcc/.claude/commands/iniciar-projeto.md`
- [x] `ferramenta-tcc/.gemini/gemini-extension.json` *(D11)*
- [x] `ferramenta-tcc/.gemini/commands/iniciar-projeto.toml`

### Skill transversal: traducao-leigo (D19) — antes das skills M1
- [x] `ferramenta-tcc/core/skills/traducao-leigo/SKILL.md`

### Marco 1: sub-agente stakeholder-identifier + 6 skills + workflow
- [x] `ferramenta-tcc/core/skills/vision-box/SKILL.md`
- [x] `ferramenta-tcc/core/skills/situacao-problema/SKILL.md`
- [x] `ferramenta-tcc/core/skills/stakeholder-mapping/SKILL.md`
- [x] `ferramenta-tcc/core/skills/contexto-e-limite/SKILL.md`
- [x] `ferramenta-tcc/core/skills/clarificacao-pos-visao/SKILL.md` *(D16 — ≤3 perguntas, só se ≥2 lacunas críticas)*
- [x] `ferramenta-tcc/core/skills/traducao-gate/SKILL.md` *(D18 — gera versão leigo + normativa)*
- [x] `ferramenta-tcc/core/workflows/m1-visao.md`
- [x] Adapters M1: wrappers `.claude/agents/` e `.gemini/agents/` para `stakeholder-identifier`

### Verificação M1 (Gemini CLI + Claude Code)
- [ ] Teste E2E Marco 1: Caso 1 (frase curta) → checklist 100% `[x]`
- [ ] Teste E2E Marco 1: Caso 2 (texto livre longo) → checklist 100% `[x]`
- [ ] Teste E2E Marco 1: Caso 3 (revisão no gate) → fluxo NÃO → revisão → SIM funciona
- [ ] Gate 1 produz versão leigo sem termos da blacklist D1

---

## Semana 4 — Marco 2: Elicitação + Análise (27/mai–02/jun)

### Sub-agentes collector + modeler (completos) + 8 skills + workflow M2
- [x] `ferramenta-tcc/core/agents/collector.md` *(completo — elicitação)*
- [x] `ferramenta-tcc/core/agents/modeler.md` *(completo — classificação/priorização)*
- [x] `ferramenta-tcc/core/skills/entrevista-estruturada/SKILL.md` *(IREB §4.2 + 4 perguntas-âncora Dani)*
- [x] `ferramenta-tcc/core/skills/cenario-narrativa/SKILL.md` *(material Dani n08)*
- [x] `ferramenta-tcc/core/skills/questionario-feixe/SKILL.md`
- [x] `ferramenta-tcc/core/skills/classificacao-rf-rnf/SKILL.md` *(IREB §1.1 + 9 buckets Wiegers Ch7)*
- [x] `ferramenta-tcc/core/skills/priorizacao/SKILL.md` *(D9: MoSCoW MVP + Kano + IEEE sub-rotinas)*
- [x] `ferramenta-tcc/core/skills/glossario/SKILL.md` *(anti-ambiguidade — Wiegers Ch11)*
- [x] `ferramenta-tcc/core/skills/pautas-reelicitacao/SKILL.md` *(Livro SON cap. 8 Fig. 8.3)*
- [x] `ferramenta-tcc/core/skills/conflitos-detect/SKILL.md` *(IREB §4.4: 6 tipos + 4 estratégias — versão M2)*
- [x] `ferramenta-tcc/core/skills/recomendacao-implicitos/SKILL.md` *(lê catalogos-seed/rfs-tipicos + rnfs-tipicos)*
- [x] `ferramenta-tcc/core/skills/recomendacao-dominio/SKILL.md` *(lê catalogos-seed/dominios/)*
- [x] `ferramenta-tcc/core/workflows/m2-requisitos.md`
- [x] Adapters M2: wrappers `.claude/agents/` e `.gemini/agents/` para collector + modeler
- [x] `ferramenta-tcc/tests/marco-2/casos.md` (3 casos canônicos)
- [x] `ferramenta-tcc/tests/marco-2/checklist.md` (20 critérios)

### Verificação M2 (Gemini CLI + Claude Code)
- [ ] Loop collector ⇄ modeler funciona
- [ ] Gate 2 bloqueado se `pautas-reelicitacao.md` tem pendências
- [ ] Gate 2 abre após resolução de pendências
- [ ] Versão leigo de artefatos M2 sem termos da blacklist D1

---

## Semana 5 — Marco 3: SRS + Validação + specs + tests + M4 (03–09/jun)

### Sub-agentes checker + documenter (completos) + 8 skills + workflow M3
- [x] `ferramenta-tcc/core/agents/checker.md` *(completo — validação IREB §3.8 + analyze + M4)*
- [x] `ferramenta-tcc/core/agents/documenter.md` *(completo — gera 5 outputs)*
- [x] `ferramenta-tcc/core/skills/requisito-ears/SKILL.md` *(D8: EARS + slots + RFC 2119)*
- [x] `ferramenta-tcc/core/skills/srs-ireb-template/SKILL.md` *(IREB §3.3.3, 6 seções)*
- [x] `ferramenta-tcc/core/skills/validacao-checklist-ireb/SKILL.md` *(IREB §3.8: 6+6 critérios)*
- [x] `ferramenta-tcc/core/skills/rastreabilidade-matriz/SKILL.md` *(matriz D/R)*
- [x] `ferramenta-tcc/core/skills/analyze-cross-artifact/SKILL.md` *(D17: CRITICAL/HIGH/MEDIUM/LOW)*
- [x] `ferramenta-tcc/core/skills/gherkin-spec/SKILL.md` *(D20/D22: Gherkin para RFs `DEVE`)*
- [x] `ferramenta-tcc/core/skills/step-defs-red/SKILL.md` *(D20: step defs RED nos 3 frameworks)*
- [x] `ferramenta-tcc/core/skills/testing-strategy/SKILL.md` *(D21: TESTING-STRATEGY.md por RNF)*
- [x] `ferramenta-tcc/core/skills/readme-tests/SKILL.md` *(D23: README-TESTS.md — 3 frameworks)*
- [x] Gate M4 no orquestrador: `checker` em modo técnico, `aprovacao-tecnica.md` — D24 opcional
- [x] `ferramenta-tcc/core/workflows/m3-srs-specs-tests.md`
- [x] Adapters M3: wrappers `.claude/agents/` e `.gemini/agents/` para checker + documenter
- [x] `ferramenta-tcc/tests/marco-3/casos.md` (3 casos canônicos)
- [x] `ferramenta-tcc/tests/marco-3/checklist.md` (20 critérios)

### Seleção do caso de estudo
- [ ] Definir projeto real com orientador
- [ ] Confirmar domínio → completar catálogo seed correspondente (se diferente dos 5 já existentes)
- [ ] Agendar sessão com stakeholder real para semana 6

### Verificação M3 (Gemini CLI + Claude Code)
- [ ] Loop documenter ⇄ checker funciona
- [ ] `analyze-report.md` sem CRITICAL antes do Gate 3 (D17)
- [ ] SRS tem estrutura IREB §3.3.3 completa (6 seções)
- [ ] Versão leigo do SRS sem termos da blacklist D1 (D18+D19)
- [ ] `spec/*.feature` gerado para RFs com modal `DEVE` (D20)
- [ ] `tests/{unit,acceptance}/` contém step defs em estado RED (D20)
- [ ] `TESTING-STRATEGY.md` gerado com entradas por RNF (D21)
- [ ] `README-TESTS.md` cobre 3 frameworks (D23)
- [ ] Gate M4 (opcional): checklist técnico + `aprovacao-tecnica.md` funciona (D24)

### Skills stretch (só com folga após verificação M3)
- [ ] `casos-de-uso/SKILL.md`
- [ ] `complexity-analysis/SKILL.md` *(Axiomatic Design — Gorski)*
- [ ] `historia-de-usuario/SKILL.md`
- [ ] `requisito-smart/SKILL.md`
- [ ] `requisito-qualidade-furps/SKILL.md`
- [ ] Expandir `rastreabilidade-matriz` com algoritmo Zigzag ZAG/ZIG + coverage matrix

---

## Semana 6 — Estudo de caso (10–16/jun)

- [ ] Executar pipeline completo (Marco 1 → 2 → 3) com stakeholder real
- [ ] Registrar todas as sessões em `sessoes/SXX.md`
- [ ] Coletar SRS final gerado
- [ ] Registrar: quantos itens Implícitos foram aceitos, quantos conflitos detectados/resolvidos

---

## Semana 7 — Análise + início da redação (17–23/jun)

- [ ] Aplicar rubrica IREB §3.8 sobre o SRS gerado (6+6 critérios)
- [ ] Aplicar checklist Livro 1 sobre o SRS gerado
- [ ] Comparar com SRS de referência (se disponível) ou avaliar só pela rubrica
- [ ] Iniciar redação do TCC: introdução, fundamentação teórica, metodologia

---

## Semana 8 — Finalização (24/jun–01/jul)

- [ ] Concluir redação: resultados, discussão, conclusão, referências
- [ ] Revisão final com orientador
- [ ] Entrega 🎯

---

## Mitigações de risco

| Risco | Gatilho | Mitigação |
|---|---|---|
| D12 migration incompleta | Novos agentes criados em `.gemini/` em vez de `core/` | Task de migração no início de Semana 3; checklist de caminhos antes de criar qualquer novo arquivo |
| Semana 3 ou 4 atrasam | Agentes não testados E2E até sexta | Cortar 1 skill stretch por semana de atraso |
| Semana 5 sobrecarregada | checker + documenter + 8 skills + M4 em 1 semana | Cortar Gate M4 (deixar como stub); cortar skills stretch; priorizar documenter → checker → gherkin-spec → testing-strategy |
| T5 — Gate M4 amplia escopo (D24) | Semana 5 sobrecarregada | Gate M4 é MVP opcional — entregar stub funcional (checklist gerado) e `aprovacao-tecnica.md`; fluxo completo como stretch |
| Estudo de caso difícil de executar | Stakeholder indisponível | Focar em caso simulado; Gemini CLI como plataforma principal |
| Porte Claude Code atrasado | Semana 5 sobrecarregada | Manifestos criados na Semana 3 (D11) mitiga; adapters são thin wrappers — não cortar, mas pode simplificar |

---

## Decisões ainda a tomar (com o orientador)

- [ ] Projeto específico para o estudo de caso
- [ ] SRS de referência disponível para comparação (ou só rubrica IREB)?
- [ ] Quem avalia o SRS gerado: orientador, banca ou rubrica automatizada?
- [ ] Quais skills stretch executar na semana 5? (`casos-de-uso`, `complexity-analysis`, `historia-de-usuario`, `requisito-smart`, `requisito-qualidade-furps` — Kano e IEEE já como sub-rotinas de `priorizacao`)