# ROADMAP — Ferramenta de Elicitação de Requisitos

**Prazo final:** 2026-07-01  
**Atualizado em:** 2026-05-06 → 2026-05-17 (D12-D19: engine canônico, D16, D17, D18, D19, D15, D13; D20-D24: sdd-spec-generator, test-case-generator, testing-strategy-generator, readme-tests-generator, Gate M4)

---

## Fase 0 — Planejamento ✅

- [x] Pré-projeto escrito e submetido ao orientador (`0 - Ideia Inicial.md`)
- [x] Arquitetura de agentes e skills definida via brainstorming (`docs/arquitetura-agentes-skills.md`)
- [x] Decisões de design registradas (`docs/decisoes-de-design.md`)
- [x] `CLAUDE.md` e `ROADMAP.md` criados

**Próximo passo imediato:** Criar `clarificacao-pos-visao/SKILL.md` (D16) e `traducao-leigo/SKILL.md` (D19) → executar testes E2E do Marco 1 → avançar para Semana 3 com migração D12.

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
- [ ] Criar `ferramenta-tcc/gemini-extension.json` (manifesto extensão Gemini CLI) — D11
- [ ] Criar `ferramenta-tcc/.claude-plugin/plugin.json` (manifesto plugin Claude Code) — D11

---

## Semana 2 — Marco 1: Visão do Produto (13–19/mai)

### Sub-agente Implícitos (base dos catálogos seed)
- [x] `ferramenta-tcc/.gemini/agents/implicitos.md`

### Agente Visão do Produto (5 skills MVP)
- [x] `ferramenta-tcc/.gemini/agents/visao-produto.md`
- [x] `ferramenta-tcc/.gemini/skills/input-normalizer/SKILL.md`
- [x] `ferramenta-tcc/.gemini/skills/vision-box-conductor/SKILL.md`
- [x] `ferramenta-tcc/.gemini/skills/stakeholder-mapping/SKILL.md`
- [x] `ferramenta-tcc/.gemini/skills/contexto-e-limite-builder/SKILL.md`
  *(arquivos acima em `.gemini/` — migração para `core/` no início da Semana 3 — D12)*
- [ ] `ferramenta-tcc/core/skills/clarificacao-pos-visao/SKILL.md` *(D16 — máx. 3 perguntas, só se ≥2 lacunas críticas detectadas)*
- [x] `ferramenta-tcc/tests/marco-1/casos.md` (3 casos canônicos com comportamento esperado)
- [x] `ferramenta-tcc/tests/marco-1/checklist.md` (20 critérios objetivos)

### Skill transversal: tradução-leigo (D19)
- [ ] `ferramenta-tcc/core/skills/traducao-leigo/SKILL.md` *(verifica jargão da blacklist D1 + gera alternativa em linguagem de negócio; invocável por qualquer agente)*

### Verificação (pendente — executar manualmente no Gemini CLI)
- [ ] Teste E2E Marco 1: Caso 1 (frase curta) → checklist 100% `[x]`
- [ ] Teste E2E Marco 1: Caso 2 (texto livre longo) → checklist 100% `[x]`
- [ ] Teste E2E Marco 1: Caso 3 (revisão no mini-gate) → fluxo de retorno funciona
- [ ] Gate 1 testado: NÃO → revisão de etapa → SIM → encerramento correto

---

## Semana 3 — Marco 2: Elicitação + Análise (20–26/mai)

### Migração para engine canônico (D12) — início da semana
- [ ] Mover `ferramenta-tcc/.gemini/agents/` → `ferramenta-tcc/core/agents/` (Visão + Implícitos)
- [ ] Mover `ferramenta-tcc/.gemini/skills/` → `ferramenta-tcc/core/skills/` (5 skills do Marco 1 + tradução-leigo)
- [ ] Criar adapter `.gemini/` com wrappers/symlinks apontando para `core/`
- [ ] Criar adapter `.claude/` com wrappers para `core/` (porte MVP — D11/D12)

### Sub-agente Conflitos
- [ ] `ferramenta-tcc/core/agents/conflitos.md`

### Agente Elicitação (4 skills MVP)
- [ ] `ferramenta-tcc/core/agents/elicitacao.md`
- [ ] `ferramenta-tcc/core/skills/entrevista-estruturada/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/cenario-narrativa/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/questionario-feixe/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/brainstorming-guiado/SKILL.md`

### Agente Análise (4 skills MVP)
- [ ] `ferramenta-tcc/core/agents/analise.md`
- [ ] `ferramenta-tcc/core/skills/classificacao-rf-rnf/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/priorizacao/SKILL.md` *(consolida MoSCoW MVP + Kano e IEEE como sub-rotinas stretch — D9)*
- [ ] `ferramenta-tcc/core/skills/glossario-builder/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/pautas-reelicitacao/SKILL.md`

### Verificação
- [ ] Loop Elicitação ⇄ Análise funciona
- [ ] Gate 2 bloqueado se `pautas-reelicitacao.md` tem pendências
- [ ] Gate 2 abre após resolução de pendências

---

## Semana 4 — Marco 3: SRS + Validação (27/mai–02/jun)

### Sub-agentes NLP e Visualização
- [ ] `ferramenta-tcc/core/agents/nlp.md`
- [ ] `ferramenta-tcc/core/agents/visualizacao.md`

### Agente SRS (4 skills MVP)
- [ ] `ferramenta-tcc/core/agents/srs.md`
- [ ] `ferramenta-tcc/core/skills/srs-ireb-template/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/requisito-ears/SKILL.md` *(EARS + slots estruturados + RFC 2119 — D8)*
- [ ] `ferramenta-tcc/core/skills/srs-consolidator/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/sdd-spec-generator/SKILL.md` *(D20/D22 — lê RFs DEVE e gera spec/*.feature em Gherkin)*

### Agente Validação (8 skills — todas MVP)
- [ ] `ferramenta-tcc/core/agents/validacao.md`
- [ ] `ferramenta-tcc/core/skills/validacao-checklist-ireb-3-8/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/validacao-checklist-livro-1/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/rastreabilidade-matriz/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/validacao-cliente-roteiro/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/analyze-cross-artifact/SKILL.md` *(D17 — consistência Visão↔Elicitação↔SRS; CRITICAL bloqueia gate)*
- [ ] `ferramenta-tcc/core/skills/traducao-gate/SKILL.md` *(D18 — gera versão leigo de cada artefato-gate)*
- [ ] `ferramenta-tcc/core/skills/test-case-generator/SKILL.md` *(D20 — gera step definitions em estado RED para cada .feature)*
- [ ] `ferramenta-tcc/core/skills/testing-strategy-generator/SKILL.md` *(D21 — gera TESTING-STRATEGY.md com categoria/ferramenta/métrica por RNF)*

### Verificação
- [ ] Loop SRS ⇄ Validação funciona
- [ ] SRS gerado tem estrutura IREB §3.3.3 completa
- [ ] `aprovacao-leigo-m3.md` gerado em linguagem sem jargão (D18)
- [ ] `analyze-report.md` sem issues CRITICAL antes do Gate 3 (D17)
- [ ] Gate 3 funciona
- [ ] `spec/*.feature` gerado para RFs com modal `DEVE` (D20)
- [ ] `tests/` contém step definitions em estado RED (D20)
- [ ] `TESTING-STRATEGY.md` gerado com entradas por RNF (D21)

---

## Semana 5 — Gerência + Recomendação + stretch (03–09/jun)

### Sub-agente Recomendação
- [ ] `ferramenta-tcc/core/agents/recomendacao.md`
- [x] Catálogos seed: `saude.md` e `dashboard.md` ✅ *(antecipados para Semana 1)*
- [ ] Completar catálogo seed do domínio específico do caso de estudo (se diferente dos 5 já existentes)

### Agente Gerência (8 skills MVP)
- [ ] `ferramenta-tcc/core/agents/gerencia.md`
- [ ] `ferramenta-tcc/core/skills/versionamento-git/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/baseline-snapshot/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/change-control/SKILL.md`
- [ ] `ferramenta-tcc/core/skills/detection-based-recovery/SKILL.md` *(D10 — fallback quando `estado-projeto.yaml` ausente/ilegível)*
- [ ] `ferramenta-tcc/core/skills/constitution-builder/SKILL.md` *(D15 — gera `constitution.md` no início de cada projeto)*
- [ ] `ferramenta-tcc/core/skills/estado-yaml/SKILL.md` *(D13 — cria e atualiza `estado-projeto.yaml`; SoT primário de recovery)*
- [ ] `ferramenta-tcc/core/skills/readme-tests-generator/SKILL.md` *(D23 — gera README-TESTS.md pós-Gate 3 com instruções para 3 frameworks)*
- [ ] `ferramenta-tcc/core/skills/marco4-revisao-tecnica/SKILL.md` *(D24 — opcional: checklist técnico + aprovacao-tecnica.md para Gate M4)*

### Skills stretch (só se semana 4 terminou no prazo)
- [ ] `casos-de-uso/SKILL.md`
- [ ] `complexity-analysis/SKILL.md` *(Axiomatic Design — inspirado no Problem-Based-SRS)*
- [ ] `historia-de-usuario/SKILL.md`
- [ ] `requisito-smart/SKILL.md`
- [ ] `requisito-qualidade-furps/SKILL.md`
- [ ] Expandir `rastreabilidade-master/SKILL.md` com algoritmo Zigzag ZAG/ZIG + coverage matrix

### Seleção do caso de estudo
- [ ] Definir projeto real com orientador
- [ ] Confirmar domínio → completar catálogo seed correspondente
- [ ] Agendar sessão com stakeholder real para semana 6

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
| Semana 5 atrasada | Gerência ou Recomendação não prontos | Recomendação fica com seed de 2-3 domínios; stretch cortado |
| T5 — Gate M4 amplia escopo (D24) | Semana 5 sobrecarregada | `marco4-revisao-tecnica/SKILL.md` é MVP opcional — entregar o mínimo (checklist gerado) e confirmar Gate M4 funcional; fluxo completo como stretch |
| Estudo de caso difícil de executar | Stakeholder indisponível | Porte Claude Code suspenso; energia no caso de estudo |
| Porte Claude Code atrasado | Semana 5 sobrecarregada | Empacotamento desde Semana 1 (D11) mitiga; porte é objetivo MVP confirmado — não cortar |

---

## Decisões ainda a tomar (com o orientador)

- [ ] Projeto específico para o estudo de caso
- [ ] SRS de referência disponível para comparação (ou só rubrica IREB)?
- [ ] Quem avalia o SRS gerado: orientador, banca ou rubrica automatizada?
- [ ] Quais skills stretch executar na semana 5? (`casos-de-uso`, `complexity-analysis`, `historia-de-usuario`, `requisito-smart`, `requisito-qualidade-furps` — Kano e IEEE já como sub-rotinas de `priorizacao`)